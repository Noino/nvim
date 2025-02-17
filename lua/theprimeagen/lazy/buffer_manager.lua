return {
    "noino/buffer_manager.nvim",
    branch = "autocmd_save_tweaking",
    config = function()

        require("buffer_manager").setup({
            width = -80,
            height = -50
        })
        local bmgr = require("buffer_manager.ui")
        vim.keymap.set("n", "<leader>b", function() bmgr.toggle_quick_menu() end )

        --        local augrp = vim.api.nvim_create_augroup('autobuffer', { clear = true })

        local function get_buffer_state_dir()
            return (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME")) .. "/.buffer_manager/"
        end

        local function get_buffer_state_file()
            return get_buffer_state_dir() .. vim.fn.getcwd(0):gsub("/", "_")
        end

        local function save_buf_according_to_dir()
            bmgr.save_menu_to_file(get_buffer_state_file())
        end

        local function load_buf_according_to_dir()
            local buffer_state_file = get_buffer_state_file()
            if vim.fn.filereadable(buffer_state_file) == 1 then
                bmgr.load_menu_from_file(buffer_state_file)
            end
        end

        vim.api.nvim_create_user_command("Bs", function()
            save_buf_according_to_dir()
        end, {})

        vim.api.nvim_create_user_command("Bl", function()
            load_buf_according_to_dir()
        end, {})

--        vim.keymap.set("n", "<leader>bs", save_buf_according_to_dir)
--        vim.keymap.set("n", "<leader>bl", load_buf_according_to_dir )

        --        vim.api.nvim_create_autocmd("VimEnter", {
        --            pattern = "*",  -- Can be specific if you only want to target certain files
        --            group = augrp,
        --            callback = function()
        --                vim.fn.mkdir(get_buffer_state_dir(), "p")
        --                if vim.fn.argc() == 0 then
        --                    local buffer_state_file = get_buffer_state_file()
        --                    if vim.fn.filereadable(buffer_state_file) == 1 then
        --                        bmgr.load_menu_from_file(buffer_state_file)
        --                    end
        --                end
        --            end,
        --        })
        --
        --        vim.api.nvim_create_autocmd({"BufEnter", "BufLeave", "QuitPre", "VimLeave"}, {
        --            pattern = "*",  -- Runs for all buffers
        --            group = augrp,
        --            callback = function(e)
        --                if (e.event == "BufEnter" or e.event == "BufLeave")
        --                and (e.file == nil or e.file == "") then
        --                    return
        --                end
        --                bmgr.save_menu_to_file(get_buffer_state_file())
        --            end,
        --        })
        --
        --
        --vim.api.nvim_create_autocmd({ "QuitPre", "VimLeave" }, {
        --    pattern = '*',
        --    callback = function(event)
        --        -- Extract event details
        --        local event_name = event.event
        --        local buffer_number = event.buf
        --        local file_name = event.file
        --
        --        -- Construct the notification message
        --        local message = string.format(
        --            "Event: %s\nBuffer Number: %d\nFile Name: %s",
        --            event_name,
        --            buffer_number,
        --            file_name
        --        )
        --
        --        vim.api.nvim_out_write(message)
        --    end,
        --})

    end
}
