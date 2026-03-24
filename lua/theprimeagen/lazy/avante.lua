return {
    "yetone/avante.nvim",
    build = "make BUILD_FROM_SOURCE=true",
    cond = function()
        return not vim.g.utility_mode
    end,
    event = "VeryLazy",
    opts = {
        instructions_file = ".github/copilot-instructions.md",
        provider = "copilot/gpt-5.3-codex",
        auto_suggestions_provider = "copilot/gpt-5.1-codex-mini",
        mode = "agentic",
        providers = {
            ["copilot/gpt-5.1-codex-mini"] = {
                __inherited_from = "copilot",
                model = "gpt-5.1-codex-mini",
                display_name = "codex-mini",
                extra_request_body = {
                    max_tokens = 8192,
                    temperature = 0.0,
                },
                disable_tools = true,
            },

            ["copilot/gpt-5.3-codex"] = {
                __inherited_from = "copilot",
                model = "gpt-5.3-codex",
                display_name = "codex-5.3",
                extra_request_body = {
                    max_tokens = 65536,
                    temperature = 0.0,
                },
                disable_tools = true,
            },

            ["copilot/claude-opus-4.6"] = {
                __inherited_from = "copilot",
                model = "claude-opus-4.6",
                display_name = "opus-4.6",
                extra_request_body = {
                    max_tokens = 65536,
                    temperature = 0.1, -- allow thinking here
                },
                disable_tools = true,
            },
        },

        hints = { enabled = true },
        selector = {
            provider = "telescope",
        },
        behavior = {
            auto_suggestions = false,

            auto_apply_diff_after_generation = false,
            auto_approve_tool_permissions = false,

            minimize_diff = true,
            enable_fastapply = true,

            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            support_paste_from_clipboard = false,
            enable_token_counting = true,
        },

        selection = {
            enabled = true,
            hint_display = "delayed",
            delay = 300,
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
            debounce = 1000,
            throttle = 300,
        },
    },

    config = function(_, opts)
        require("avante").setup(opts)
    end,

    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "stevearc/dressing.nvim",
        "folke/snacks.nvim",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },

    keys = {
        {
            "<leader>am",
            function()
                local cfg = require("avante.config")

                local current = cfg.provider
                local next = (current == "copilot/gpt-5.3-codex")
                    and "copilot/claude-opus-4.6"
                    or "copilot/gpt-5.3-codex"

                cfg.override({ provider = next })
                vim.notify("Avante model: " .. next)
            end,
            desc = "toggle Avante model",
        },

        {
            "<leader>a+",
            function()
                require("avante.extensions.nvim_tree").add_file()
            end,
            desc = "Select file in NvimTree",
            ft = "NvimTree",
        },
        {
            "<leader>a-",
            function()
                require("avante.extensions.nvim_tree").remove_file()
            end,
            desc = "Deselect file in NvimTree",
            ft = "NvimTree",
        },
    },
}
