local map = vim.keymap.set

local buffer_map = function(modes, lhs, rhs)
    vim.keymap.set(modes, lhs, rhs, { buffer  = true })
end

local tm = require("plugins.telescope").telescope_map

local M = {}
M.on_attach = function(client)

    require('lsp_signature').on_attach({
        bind = true,
        hint_enable = true,
        fix_pos = false,
        hint_prefix = " ",
        hint_scheme = "String",
        handler_opts = { border = "single" }
    })

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
        client.config.flags.debounce_text_changes  = 100
    end

    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    buffer_map ("n", "gd", vim.lsp.buf.definition)
    buffer_map ("n", "gD", vim.lsp.buf.declaration)
    buffer_map ("n", "gi", vim.lsp.buf.implementation)
    buffer_map ("n", "gt", vim.lsp.buf.type_definition)
    buffer_map ("n", "gr", vim.lsp.buf.references)
    buffer_map ("n", "K",  vim.lsp.buf.hover)
    buffer_map ("n", "gR", vim.lsp.buf.rename)
    buffer_map ("n", "<leader>lR", vim.lsp.buf.rename)
    buffer_map ({"n", "x"}, "ga", vim.lsp.buf.code_action)

    buffer_map ("n", "[d", vim.diagnostic.goto_prev)
    buffer_map ("n", "]d", vim.diagnostic.goto_next)
    buffer_map ("n", "<leader>lc", function() vim.diagnostic.hide(nil, 0) end)
    buffer_map ("n", "<leader>ll", vim.diagnostic.open_float)
    buffer_map ("n", "<leader>lQ", vim.diagnostic.setloclist)
    map ("n", "<leader>lx", ":LspStop<CR>",  { silent = true })
    map ("n", "<leader>lX", ":LspStart<CR>", { silent = true })

    tm("<leader>lr", "lsp_references",                true)
    tm("<leader>la", "lsp_code_actions",              true)
    tm("<leader>la", "lsp_range_code_actions",        true)
    tm("<leader>ld", "lsp_definitions",               true)
    tm("<leader>li", "lsp_implementations",           true)
    tm("<leader>lg", "lsp_document_diagnostics",      true)
    tm("<leader>lG", "lsp_workspace_diagnostics",     true)
    tm("<leader>ls", "lsp_document_symbols",          true)
    tm("<leader>lS", "lsp_dynamic_workspace_symbols", true)


    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec ([[
    	    hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
    	    hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
    	    hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
    	    augroup lsp_document_highlight
    	    	autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    	    augroup END ]], false)
    end

    if client.server_capabilities.document_formatting then
        buffer_map ("n", "<leader>lf", vim.lsp.buf.formatting)
    elseif client.server_capabilities.document_range_formatting then
        buffer_map ("n", "<leader>lf", vim.lsp.buf.range_formatting)
    end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
local completion_item = M.capabilities.textDocument.completion.completionItem
completion_item.snippetSupport = true
completion_item.preselectSupport = true
completion_item.insertReplaceSupport = false
completion_item.labelDetailsSupport = true
completion_item.deprecatedSupport = true
completion_item.commitCharactersSupport = true
completion_item.tagSupport = { valueSet = { 1 } }
completion_item.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
}

vim.fn.sign_define("LspDiagnosticsSignError",       { text = "", numhl = "LspDiagnosticsSignError"       })
vim.fn.sign_define("LspDiagnosticsSignWarning",     { text = "", numhl = "LspDiagnosticsSignWarning"     })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsSignInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint",        { text = "", numhl = "LspDiagnosticsSignHint"        })

local function client_is_configured(server_name, ft)
    ft = ft or vim.bo.filetype
    local active_autocmds = vim.api.nvim_get_autocmds({event = "FileType", pattern = ft})
    for _, autocmd in ipairs(active_autocmds) do
        if autocmd.command:match(server_name) then
            return true
        end
    end
    return false
end

local meta = {
    __index = function(_, server)
        return {
            setup = function(config)

                if client_is_configured(server) then
                    return
                end

                if config.on_attach == nil then
                    config.on_attach = M.on_attach
                end
                config.capabilities = M.capabilities

                local lspconfig = require("lspconfig")
                lspconfig[server].setup(config)
                lspconfig[server].manager.try_add_wrapper() --so we can use this in ftplugins
            end
        }
    end
}

setmetatable(M, meta)

return M
