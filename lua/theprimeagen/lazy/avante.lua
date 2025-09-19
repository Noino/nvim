return {
    "yetone/avante.nvim",
    cond = function()
        return not vim.g.utility_mode
    end,
    event = "VeryLazy",
    opts = {
        mode = "agentic",
        auto_apply = false,
        confirm_actions = true,
        -- disabled_tools = { "bash", "python"},
        -- instructions_file = "avante.md",
        provider = "copilot",
        providers = {
            copilot = {
                model = "claude-sonnet-4",
                timeout = 30000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.1,
                },
            },
        },
        selector = {
            exclude_auto_select = { "NvimTree" },
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
        "ibhagwan/fzf-lua",              -- for file_selector provider fzf
        "stevearc/dressing.nvim",        -- for input provider dressing
        "folke/snacks.nvim",             -- for input provider snacks
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",        -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
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
