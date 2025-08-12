return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({

                disable_background = true,
                styles = {
                    italic = false,
                    transparency = true,
                },
                groups = {
                    git_add = "#3ccf38",
                    git_change = "gold",
                },
            })

            vim.cmd("colorscheme rose-pine-moon")
        end
    },


}
