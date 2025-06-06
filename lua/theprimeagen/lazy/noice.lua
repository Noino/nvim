return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    },
    config = function()
        require("telescope").load_extension("noice")
        local palette = require('rose-pine.palette')
        vim.opt.showmode = false

        require("notify").setup({
            background_colour = palette.base,
            render = "default",
        })

        require("noice").setup({
            lsp = {
                -- progress = {
                --     enabled = true,
                --     format = 'lsp_progress',
                --     format_done = 'lsp_progress_done',
                --     view = 'notify',
                -- },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },

            cmdline = { view = "cmdline" },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = true,            -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "search_count",
                    },
                    opts = { skip = true },
                },
                --{
                --    filter = {
                --        event = "msg_show",
                --        kind = "",
                --        blocking = true,
                --    },
                --    view = "popup",
                --},
                --                {
                --                    filter = {
                --                        event = "notify",
                --                        find = "No information available"
                --                    },
                --                    opts = {
                --                        skip = true
                --                    },
                --                },
            },
        })
    end

}
