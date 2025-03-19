return {
    'Noino/sessioneer.nvim',
    -- dir = '~/git/sessioneer.nvim',
    -- dev = true,
    lazy = false,
    cond = function()
        return not vim.g.utility_mode
    end,
    config = function()
        require "sessioneer".setup({})
    end
}
