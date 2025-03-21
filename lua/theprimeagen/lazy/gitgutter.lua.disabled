return {
    {
        "airblade/vim-gitgutter",
        cond = function()
            return not vim.g.utility_mode
        end,
        config = function()
            vim.keymap.set("n", "<leader><", vim.cmd.GitGutterPrevHunk)
            vim.keymap.set("n", "<leader>>", vim.cmd.GitGutterNextHunk)
        end
    }
}
