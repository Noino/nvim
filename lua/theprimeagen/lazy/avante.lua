return {
    "yetone/avante.nvim",
    build = "make BUILD_FROM_SOURCE=true",
    cond = function()
        return not vim.g.utility_mode
    end,
    event = "VeryLazy",
    opts = {
        provider = "copilot",
        mode = "legacy",
        providers = {
            copilot = {
                model = "claude-sonnet-4",
                extra_request_body = {
                    temperature = 0.1,
                },
                auto_select_model = false,
            },
        },
        hints = { enabled = true },
        selector = {
            provider = "telescope",
        },
        behavior = {
            auto_suggestions = false,
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = false,
            minimize_diff = true,
            enable_token_counting = true,
            auto_approve_tool_permissions = false,
            enable_fastapply = false,
        },
        selection = {
            enabled = true,
            hint_display = "delayed",
        },
                highlights = {
            diff = {
                current = "DiffText",
                incoming = "DiffAdd",
            },
        },
        diff = {
            autojump = true,
            list_opener = "copen",
            override_timeoutlen = 500,
        },
        suggestion = {
            debounce = 15000,
            throttle = 1000,
        },
    },
    config = function(_, opts)
        require("avante").setup(opts)
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "stevearc/dressing.nvim",        -- for input provider dressing
        "folke/snacks.nvim",             -- for input provider snacks
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",        -- for providers='copilot'
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
    keys = {
        {
            '<leader>at',
            function()
                local cfg = require("avante.config") -- config module (not require("avante").config)
                local api = require("avante.api")

                local cur = cfg.mode or "agentic"
                local nxt = (cur == "agentic") and "legacy" or "agentic"

                -- override merges your change into the runtime config
                cfg.override({ mode = nxt })

                -- refresh Avante windows; fallback to commands if needed
                if not pcall(api.refresh) then
                    vim.cmd('AvanteStop')
                    vim.cmd('AvanteRefresh')
                end

                vim.notify(("Avante switched to %s mode"):format(nxt), vim.log.levels.INFO)
            end,
            desc = "toggle Avante mode",
        },
        {
            "<leader>a+",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.add_file()
            end,
            desc = "Select file in NvimTree",
            ft = "NvimTree",
        },
        {
            "<leader>a-",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.remove_file()
            end,
            desc = "Deselect file in NvimTree",
            ft = "NvimTree",
        },
    },
}
