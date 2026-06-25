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

    local function switch_away_if_current(name)
        local current = vim.trim(vim.fn.system('tmux display-message -p "#S"'))
        if current == name then
            vim.fn.system('tmux switch-client -n 2>/dev/null || tmux switch-client -p 2>/dev/null')
        end
    end

    require('telescope').extensions.tmux.sessions({
        quit_on_select = true,
        attach_mappings = function(prompt_bufnr, map)
            -- M-d: smart teardown, keep picker open, refresh when done
            map({ 'i', 'n' }, '<M-d>', function()
                local name = state.get_selected_entry().display
                switch_away_if_current(name)
                vim.fn.jobstart({ 'bash', '-lc', 'amux rm ' .. vim.fn.shellescape(name) }, {
                    on_exit = function()
                        vim.schedule(function() refresh(prompt_bufnr) end)
                    end,
                })
            end)

            -- M-x: vanilla kill, keep picker open
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
