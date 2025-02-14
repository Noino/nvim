return {
    "noino/buffer_manager.nvim",
    config = function()
        require("buffer_manager").setup({
            width = -80,
            height = -50
        })
        local bmgr = require("buffer_manager.ui")
        vim.keymap.set("n", "<leader>b", function() bmgr.toggle_quick_menu() end )

    end
}
