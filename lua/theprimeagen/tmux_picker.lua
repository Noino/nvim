local M = {}

-- Every destructive action logs before acting. Sessions have been vanishing with their
-- worktrees and amux state left intact -- the signature of a raw kill-session rather than
-- amux rm -- and post-hoc evidence could not identify the caller. With this, a session
-- that dies WITHOUT a matching line here was killed by something outside this picker.
local EVENT_LOG = vim.fn.expand('~/.local/state/amux/session-events.log')
local function log_action(action, name)
    local line = string.format('%s picker:%s session=%s\n', os.date('%Y-%m-%dT%H:%M:%S'), action, name)
    local fh = io.open(EVENT_LOG, 'a')
    if fh then fh:write(line); fh:close() end
end

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
    -- captured the same way telescope-tmux does, so the switch lands on the outer client
    -- rather than this popup
    local current_client = vim.trim(vim.fn.system('tmux display-message -p "#{client_tty}"'))

    local function switch_away_if_current(name)
        if current_session ~= name then return end
        -- explicit target: relative -n/-p is unreliable from inside a display-popup
        for _, s in ipairs(sessions_list) do
            if s ~= name then
                -- trailing colon: tmux reads '.' in a target as window.pane, so a dotted session
                -- name (release branches like v5.24) is otherwise unreachable
                vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(s .. ':'))
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
            -- Enter: telescope-tmux's own select_default switches with a BARE session name
            -- (`switchc -t "v5.24"`), which tmux parses as window.pane -- so any session
            -- whose branch carries a dot (release branches like v5.24) cannot be switched
            -- to at all. Telescope chains attach_mappings with the extension's first, so
            -- replacing it here wins. Its previewer is fine: that one resolves to a
            -- session id, which has no such ambiguity.
            actions.select_default:replace(function()
                local name = state.get_selected_entry().display
                vim.cmd(string.format('silent !tmux switch-client -t %s -c %s',
                    vim.fn.shellescape(name .. ':'), vim.fn.shellescape(current_client)))
                actions.close(prompt_bufnr)
            end)

            -- M-d: smart teardown, keep picker open, refresh when done
            map({ 'i', 'n' }, '<M-d>', function()
                local name = state.get_selected_entry().display
                log_action('M-d amux-rm', name)
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
                log_action('M-D amux-rm-force', name)
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
                local name = state.get_selected_entry().display
                -- explicit 'y' only. This used to accept a bare Enter, which made an
                -- accidental keystroke enough to destroy a session and orphan its
                -- worktrees -- the leading candidate for the disappearances.
                local ok = string.lower(vim.fn.input("RAW kill '" .. name .. "'? worktrees are NOT cleaned up. [y/N] "))
                if ok ~= 'y' then return end
                log_action('M-x raw-kill-session', name)
                switch_away_if_current(name)
                vim.fn.system('tmux kill-session -t ' .. vim.fn.shellescape(name .. ':'))
                refresh(prompt_bufnr)
            end)

            return true
        end,
    })
end

return M
