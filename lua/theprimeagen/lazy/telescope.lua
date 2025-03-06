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
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>ph', function() builtin.find_files({ hidden = true }) end, {})
        vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>b', builtin.buffers, {})
    end
}
