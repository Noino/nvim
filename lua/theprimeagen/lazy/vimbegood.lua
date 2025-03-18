return {
    "theprimeagen/vim-be-good",

    cond = function()
        return not vim.g.utility_mode
    end,
    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
    end
}
