local M = {}

M.sessions = function()
    local actions = require('telescope.actions')
    local state = require('telescope.actions.state')
    local finders = require('telescope.finders')

    local function refresh(prompt_bufnr)
        local picker = state.get_current_picker(prompt_bufnr)
        local sessions = vim.fn.systemlist('tmux list-sessions -F "#S" 2>/dev/null')
        picker:refresh(
            finders.new_table({
                results = sessions,
                entry_maker = function(r)
                    return { value = r, display = r, ordinal = r }
                end,
            }),
            { reset_prompt = false }
        )
    end

    local sessions_list = vim.fn.systemlist('tmux list-sessions -F "#S" 2>/dev/null')
    local current_session = vim.trim(vim.fn.system('tmux display-message -p "#S"'))

    local function switch_away_if_current(name)
        if current_session ~= name then return end
        -- explicit target: relative -n/-p is unreliable from inside a display-popup
        for _, s in ipairs(sessions_list) do
            if s ~= name then
                vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(s))
                return
            end
        end
    end

    -- default-select the currently-attached session
    local default_index
    for i, s in ipairs(sessions_list) do
        if s == current_session then default_index = i break end
    end

    require('telescope').extensions.tmux.sessions({
        quit_on_select = true,
        default_selection_index = default_index,
        attach_mappings = function(prompt_bufnr, map)
            -- M-d: smart teardown, keep picker open, refresh when done
            map({ 'i', 'n' }, '<M-d>', function()
                local name = state.get_selected_entry().display
                switch_away_if_current(name)
                vim.fn.jobstart({ 'bash', '-lc', 'amux rm ' .. vim.fn.shellescape(name) }, {
                    on_exit = function(_, code)
                        vim.schedule(function()
                            if code ~= 0 then
                                vim.notify('amux rm failed — session may have uncommitted changes (exit ' .. code .. ')', vim.log.levels.WARN)
                            end
                            refresh(prompt_bufnr)
                        end)
                    end,
                })
            end)

            -- M-D (shift): forced teardown. This is the escape hatch for the case that
            -- used to strand worktrees: M-d refuses on a dirty/unpushed tree, you reach
            -- for M-x (raw kill, no cleanup), and once the session is gone the worktrees
            -- can no longer be torn down by name. M-D cleans up properly instead.
            map({ 'i', 'n' }, '<M-D>', function()
                local name = state.get_selected_entry().display
                local ok = string.lower(vim.fn.input("FORCE delete '" .. name .. "'? uncommitted/unpushed work is lost. [y/N] "))
                if ok ~= 'y' then return end
                switch_away_if_current(name)
                vim.fn.jobstart({ 'bash', '-lc', 'amux rm ' .. vim.fn.shellescape(name) .. ' --force' }, {
                    on_exit = function(_, code)
                        vim.schedule(function()
                            if code ~= 0 then
                                vim.notify('amux rm --force failed (exit ' .. code .. ') — run it in a shell to see why', vim.log.levels.ERROR)
                            end
                            refresh(prompt_bufnr)
                        end)
                    end,
                })
            end)

            -- M-x: vanilla kill, keep picker open.
            -- Leaves worktrees behind by design — prefer M-d / M-D for dev sessions.
            map({ 'i', 'n' }, '<M-x>', function()
                local e = state.get_selected_entry()
                local ok = string.lower(vim.fn.input("kill '" .. e.display .. "'? [Y/n] "))
                if ok ~= 'y' and ok ~= '' then return end
                switch_away_if_current(e.display)
                vim.fn.system('tmux kill-session -t ' .. vim.fn.shellescape(e.value))
                refresh(prompt_bufnr)
            end)

            return true
        end,
    })
end

return M
