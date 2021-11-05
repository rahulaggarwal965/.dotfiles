local nn = vim.keymap.nnoremap

local buf_nn = function(args)
    args.buffer = true
    vim.keymap.nnoremap(args)
end

local buf_xn = function(args)
    args.buffer = true
    vim.keymap.xnoremap(args)
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

    buf_nn { "gd", vim.lsp.buf.definition }
    buf_nn { "gD", vim.lsp.buf.declaration }
    buf_nn { "gi", vim.lsp.buf.implementation }
    buf_nn { "gt", vim.lsp.buf.type_definition }
    buf_nn { "gr", vim.lsp.buf.references }
    buf_nn { "K",  vim.lsp.buf.hover }
    buf_nn { "ga", vim.lsp.buf.code_action }
    buf_xn { "ga", vim.lsp.buf.range_code_action }
    buf_nn { "gR", vim.lsp.buf.rename }
    buf_nn { "<leader>lR", vim.lsp.buf.rename }

    buf_nn { "[d", vim.lsp.diagnostic.goto_prev }
    buf_nn { "]d", vim.lsp.diagnostic.goto_next }
    buf_nn { "<leader>lc", function() vim.lsp.diagnostic.clear(0) end }
    buf_nn { "<leader>ll", vim.lsp.diagnostic.show_line_diagnostics }
    buf_nn { "<leader>lQ", vim.lsp.diagnostic.set_loclist }
    nn { "<leader>lx", ":LspStop<CR>",  silent = true}
    nn { "<leader>lX", ":LspStart<CR>", silent = true}

    tm("<leader>lr", "lsp_references",                true)
    tm("<leader>la", "lsp_code_actions",              true)
    tm("<leader>la", "lsp_range_code_actions",        true)
    tm("<leader>ld", "lsp_definitions",               true)
    tm("<leader>li", "lsp_implementations",           true)
    tm("<leader>lg", "lsp_document_diagnostics",      true)
    tm("<leader>lG", "lsp_workspace_diagnostics",     true)
    tm("<leader>ls", "lsp_document_symbols",          true)
    tm("<leader>lS", "lsp_dynamic_workspace_symbols", true)


    if client.resolved_capabilities.document_highlight then
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

    if client.resolved_capabilities.document_formatting then
        buf_nn { "<leader>lf", vim.lsp.buf.formatting }
    elseif client.resolved_capabilities.document_range_formatting then
        buf_nn { "<leader>lf", vim.lsp.buf.range_formatting }
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

local meta = {
    __index = function(_, server)
        return {
            setup = function(config)

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
