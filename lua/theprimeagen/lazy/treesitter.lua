return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    cond = function()
        return not vim.g.utility_mode
    end,
    init = function()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                -- Enable treesitter highlighting and disable regex syntax
                pcall(vim.treesitter.start)
                -- Enable treesitter-based indentation
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
        local ensureInstalled = { "vimdoc",
            "javascript",
            "typescript",
            "lua",
            "go",
            "perl",
            "bash",
            "php",
            "hyprlang",
            "json",
            "gitignore",
            "markdown"
        }
        local alreadyInstalled = require('nvim-treesitter.config').get_installed()
        local parsersToInstall = vim.iter(ensureInstalled)
            :filter(function(parser)
                return not vim.tbl_contains(alreadyInstalled, parser)
            end)
            :totable()
        require('nvim-treesitter').install(parsersToInstall)
    end,
    config = function()
        vim.treesitter.language.register("templ", "templ")
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false
    end
}
