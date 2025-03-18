return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cond = function()
            return not vim.g.utility_mode
        end,
        opts = {},
        config = function()
            vim.keymap.set('n', '<C-f>', vim.cmd.NvimTreeToggle)
            require("nvim-tree").setup({
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                    change_dir = {
                        enable = false,
                        global = false,
                    },
                },
                hijack_directories = {
                    enable = true,
                    auto_open = true,
                },
                update_focused_file = {
                    enable = true,
                    update_root = {
                        enable = false,
                        ignore_list = {},
                    },
                    exclude = false,
                },
            })

            vim.api.nvim_create_autocmd({ "VimEnter" }, {
                callback = function() require("nvim-tree.api").tree.close() end
            })
        end

    }
}
