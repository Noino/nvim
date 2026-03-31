return {
    "yetone/avante.nvim",
    build = "make BUILD_FROM_SOURCE=true",
    cond = function()
        return not vim.g.utility_mode
    end,
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
        instructions_file = ".github/copilot-instructions.md",
        provider = "copilot/gpt-5.2-codex",
        -- auto_suggestions_provider = "copilot/gpt-5.1-codex-mini",
        mode = "agentic", -- agentic still dont allow me to be in control
        --mode = "legacy",
        disabled_tools = {
            "bash",
            "python",
            "run_python",

        --    "copy_path",
        --    "create_dir",
        --    "create_file",
            "delete_dir",
            "delete_file",
            "delete_path",
            "git_commit",
            "move_path",
            "rename_dir",
            "rename_file",
            "replace_file",
        --    "str_replace",
        --    "write_to_file",
        },
        providers = {
            ["copilot/gpt-5.1-codex-mini"] = {
                __inherited_from = "copilot",
                model = "gpt-5.1-codex-mini",
                display_name = "codex-mini",
                extra_request_body = {
                    max_tokens = 8192,
                    temperature = 0.0,
                },
            },

            ["copilot/gpt-5.2-codex"] = {
                __inherited_from = "copilot",
                model = "gpt-5.2-codex",
                display_name = "codex-5.2",
                extra_request_body = {
                    max_tokens = 65536,
                    temperature = 0.0,
                },
            },

            ["copilot/gpt-5.3-codex"] = {
                __inherited_from = "copilot",
                model = "gpt-5.3-codex",
                display_name = "codex-5.3",
                extra_request_body = {
                    max_tokens = 65536,
                    temperature = 0.0,
                },
            },

            ["copilot/claude-opus-4.6"] = {
                __inherited_from = "copilot",
                model = "claude-opus-4.6",
                display_name = "opus-4.6",
                extra_request_body = {
                    max_tokens = 65536,
                    temperature = 0.1, -- allow thinking here
                },
            },
        },

        hints = { enabled = true },
        selector = {
            provider = "telescope",
        },
        behaviour = {
            auto_approve_tool_permissions = false,
            auto_focus_sidebar = true,
            auto_suggestions = false,
            auto_suggestions_respect_ignore = true,
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            enable_fastapply = false,
            jump_result_buffer_on_finish = false,
            support_paste_from_clipboard = false,
            minimize_diff = true,
            enable_token_counting = true,
            use_cwd_as_project_root = false,
            auto_focus_on_diff_view = false,
        },
        prompt_logger = {
            enabled = true,
            log_dir = vim.fn.stdpath("cache") .. "/avante_prompts",
            fortune_cookie_on_success = false,
            next_prompt = {
                normal = "<C-n>",
                insert = "<C-n>",
            },
            prev_prompt = {
                normal = "<C-p>",
                insert = "<C-p>",
            },
        },


        edit = {
            auto_apply = false,
            diff_preview = true,
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

                local providers = {
                    "copilot/gpt-5.1-codex-mini",
                    "copilot/gpt-5.2-codex",
                    "copilot/gpt-5.3-codex",
                    "copilot/claude-opus-4.6",
                }

                local current = cfg.provider
                local index = 1
                for i, name in ipairs(providers) do
                    if name == current then
                        index = i
                        break
                    end
                end

                local next_provider = providers[(index % #providers) + 1]
                cfg.override({ provider = next_provider })
                vim.notify("Avante model: " .. next_provider)
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
