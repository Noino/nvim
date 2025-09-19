return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cond = function()
            return not vim.g.utility_mode
        end,
        keys = {
            { "<leader>tt", "<cmd>Trouble<cr>",                                                          desc = "Trouble mode select", },
            { "<leader>tn", function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "Next Trouble Item" },
            { "<leader>tp", function() require("trouble").prev({ skip_groups = true, jump = true }) end, desc = "Previous Trouble Item" },
        },
        config = function()
            require("trouble").setup({
                auto_open = false,
                auto_close = false,
                auto_preview = true,
                use_diagnostic_signs = true,
            })
        end,
    },
}
