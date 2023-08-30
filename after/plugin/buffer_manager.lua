 local bmgr = require("buffer_manager.ui")


vim.keymap.set("n", "<leader>b", function() bmgr.toggle_quick_menu() end )
