local nnoremap = vim.keymap.nnoremap
local inoremap = vim.keymap.inoremap
local xnoremap = vim.keymap.xnoremap

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

    nnoremap { "gd", vim.lsp.buf.definition, buffer = 0 }
    nnoremap { "gD", vim.lsp.buf.declaration, buffer = 0 }
    nnoremap { "gi", vim.lsp.buf.implementation, buffer = 0 }
    nnoremap { "gt", vim.lsp.buf.type_definition, buffer = 0 }
    nnoremap { "gr", vim.lsp.buf.references, buffer = 0 }
    nnoremap { "K",  vim.lsp.buf.hover, buffer = 0 }
    nnoremap { "ga", vim.lsp.buf.code_action, buffer = 0 }
    xnoremap { "ga", vim.lsp.buf.range_code_action, buffer = 0 }
    nnoremap { "gR", vim.lsp.buf.rename, buffer = 0 }
    nnoremap { "<leader>lR", vim.lsp.buf.rename, buffer = 0 }
    inoremap { "<C-k>", vim.lsp.buf.signature_help, buffer = 0 }

    nnoremap { "[d", vim.lsp.diagnostic.goto_prev, buffer = 0 }
    nnoremap { "]d", vim.lsp.diagnostic.goto_next, buffer = 0 }
    nnoremap { "<leader>lc", function() vim.lsp.diagnostic.clear(0) end, buffer = 0 }
    nnoremap { "<leader>ll", vim.lsp.diagnostic.show_line_diagnostics, buffer = 0 }
    nnoremap { "<leader>lQ", vim.lsp.diagnostic.set_loclist, buffer = 0 }

    nnoremap { "<leader>lr", function() require("telescope.builtin").lsp_references()            end }
    nnoremap { "<leader>la", function() require("telescope.builtin").lsp_code_actions()          end }
    xnoremap { "<leader>la", function() require("telescope.builtin").lsp_range_code_actions()    end }
    nnoremap { "<leader>ld", function() require("telescope.builtin").lsp_definitions()           end }
    nnoremap { "<leader>li", function() require("telescope.builtin").lsp_implementations()       end }
    nnoremap { "<leader>lg", function() require("telescope.builtin").lsp_document_diagnostics()  end }
    nnoremap { "<leader>lG", function() require("telescope.builtin").lsp_workspace_diagnostics() end }
    nnoremap { "<leader>ls", function() require("telescope.builtin").lsp_document_symbols()      end }
    nnoremap { "<leader>lS", function() require("telescope.builtin").lsp_workspace_symbols()     end }


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
        nnoremap { "<leader>lf", vim.lsp.buf.formatting, buffer = 0 }
    elseif client.resolved_capabilities.document_range_formatting then
        nnoremap { "<leader>lf", vim.lsp.buf.range_formatting, buffer = 0}
    end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits"
    }
}

vim.fn.sign_define("LspDiagnosticsSignError", { text = "", numhl = "LspDiagnosticsSignError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", numhl = "LspDiagnosticsSignWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsSignInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", numhl = "LspDiagnosticsSignHint" })

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            spacing = 0,
        },
        signs = true,
        underline = true,
    }
)

vim.lsp.protocol.CompletionItemKind = {
    "   (Text) ",
    "   (Method)",
    "   (Function)",
    "   (Constructor)",
    " ﴲ  (Field)",
    "[] (Variable)",
    "   (Class)",
    " ﰮ  (Interface)",
    "   (Module)",
    " 襁 (Property)",
    "   (Unit)",
    "   (Value)",
    " 練 (Enum)",
    "   (Keyword)",
    "   (Snippet)",
    "   (Color)",
    "   (File)",
    "   (Reference)",
    "   (Folder)",
    "   (EnumMember)",
    " ﲀ  (Constant)",
    " ﳤ  (Struct)",
    "   (Event)",
    "   (Operator)",
    "   (TypeParameter)"
}

return M
