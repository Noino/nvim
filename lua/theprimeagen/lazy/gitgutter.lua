return {
    {
        "airblade/vim-gitgutter",
        config = function()
            vim.keymap.set("n", "<leader><", vim.cmd.GitGutterPrevHunk )
            vim.keymap.set("n", "<leader>>", vim.cmd.GitGutterNextHunk )
        end
    }
}
