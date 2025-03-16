return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",

        -- tmux session & window select
        { "Noino/telescope-tmux.nvim", branch = "tweaks" },
        "norcalli/nvim-terminal.lua",
    },
    config = function()
        local telescope = require('telescope')
        telescope.setup({
            defaults = {
                layout_strategy = "horizontal",
                layout_config = {
                    width = { padding = 0 },
                    height = { padding = 0 },
                },
                sorting_strategy = "ascending",
                border = true,
            },
        })
        telescope.load_extension('tmux')
        local builtin = require('telescope.builtin')

        local seshnode = (function()
            local sn = ''
            if not vim.g.started_with_stdin then
                if vim.fn.argc() == 0 then
                    sn = vim.fn.getcwd()
                elseif vim.fn.isdirectory(vim.fn.argv(0)) ~= 0 then
                    sn = vim.fn.fnamemodify(vim.fn.argv(0), ':p:h')
                end
            end
            return sn
        end)()

        vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ cwd = seshnode }) end, {})
        vim.keymap.set('n', '<leader>ph', function() builtin.find_files({ cwd = seshnode, hidden = true }) end, {})
        vim.keymap.set('n', '<leader>pg', function() builtin.live_grep({ cwd = seshnode }) end, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>b', builtin.buffers, {})
    end
}
