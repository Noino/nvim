return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",

    config = function()
        require("copilot").setup({
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>",
                },
                layout = {
                    position = "bottom",
                    ratio = 0.4,
                },
            },

            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 120,
                keymap = {
                    accept = "<C-J>",
                    next = "<C-p>",
                    prev = "<C-l>",
                },
            },

            filetypes = {
                yaml = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
        })
    end,
}
