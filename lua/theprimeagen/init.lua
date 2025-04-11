require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.lazy_init")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = e.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', require 'telescope.builtin'.lsp_definitions, '[g]oto [d]efinitions')
        map('gr', require 'telescope.builtin'.lsp_references, '[g]oto [r]eferences')
        map('gI', require 'telescope.builtin'.lsp_implementations, '[g]oto [I]mplementations')
        map('<leader>D', require 'telescope.builtin'.lsp_type_definitions, 'Type [ D]efinitions')
        map('<leader>ds', require 'telescope.builtin'.lsp_document_symbols, '[ d]ocument [s]ymbols')
        map('<leader>ws', require 'telescope.builtin'.lsp_dynamic_workspace_symbols, '[ w]orkspace [s]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[ r]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[ c]ode [a]ction')
        map('<leader>K', vim.lsp.buf.hover, '[K]atso Hover Documentation')
        map('<C-h>', vim.lsp.buf.signature_help, 'C-[h]elp function signature', { 'n', 'i' })
        map('<leader>vd', vim.diagnostic.open_float, '[v]iew [d]iagnostic')
        map(']d', vim.diagnostic.goto_prev, 'Previous <]d>iagnostic')
        map('[d', vim.diagnostic.goto_next, 'Next <[d>iagnostic')
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
