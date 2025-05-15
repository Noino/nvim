return {
    'Noino/sessioneer.nvim',
    lazy = false,
    cond = function()
        return not vim.g.utility_mode
    end,
    config = function()
        require "sessioneer".setup({})
    end
}
