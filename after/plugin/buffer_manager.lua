 local bmgr = require("buffer_manager.ui")




vim.keymap.set("n", "<Enter>", function() bmgr.toggle_quick_menu() end )
