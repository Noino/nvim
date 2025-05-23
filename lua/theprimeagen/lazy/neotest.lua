return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "fredrikaverpil/neotest-golang",
        "olimorris/neotest-phpunit",
        "leoluz/nvim-dap-go",
        "nvim-neotest/neotest-jest",
    },
    cond = function()
        return not vim.g.utility_mode
    end,
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-golang")({
                    dap = { justMyCode = false },
                }),
                require("neotest-phpunit"),
                require('neotest-jest')({
                    jestCommand = "npx jest --testPathIgnorePatterns=e2e-tests;",
                    -- jestConfigFile = "custom.jest.config.ts",
                    env = { CI = true },
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                }),
            },
        })

        vim.keymap.set("n", "<leader>tr", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
            })
        end, { desc = "Debug: Running Nearest Test" })

        vim.keymap.set("n", "<leader>ts", function()
            require("neotest").run.run({
                suite = true,
                testify = true,
            })
        end, { desc = "Debug: Running Test Suite" })

        vim.keymap.set("n", "<leader>td", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
                strategy = "dap",
            })
        end, { desc = "Debug: Debug Nearest Test" })

        vim.keymap.set("n", "<leader>to", function()
            require("neotest").output.open()
        end, { desc = "Debug: Open test output" })
    end
}
