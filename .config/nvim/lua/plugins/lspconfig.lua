local map = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

local on_attach = function(client)

    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    map("n", "gD", "vim.lsp.buf.declaration()") 
    map("n", "gd", "vim.lsp.buf.definition()")
    map("n", "gi", "vim.lsp.buf.implementation()")
    map("n", "gr", "vim.lsp.buf.references()")

    map("n", "K", "vim.lsp.buf.hover()")
    map("i", "<C-k>", "vim.lsp.buf.signature_help()")
    -- map("n", "<leader>wa", "vim.lsp.buf.add_workspace_folder()")
    -- map("n", "<leader>wr", "vim.lsp.buf.remove_workspace_folder()")
    -- map("n", "<leader>wl", "print(vim.inspect(vim.lsp.buf.list_workspace_folders()))")
    -- map("n", "<leader>D", "vim.lsp.buf.type_definition()")
    map("n", "<leader>lr", "vim.lsp.buf.rename()")
    map("n", "<leader>e", "vim.lsp.diagnostic.show_line_diagnostics()")
    map("n", "<leader>dN", "vim.lsp.diagnostic.goto_prev()")
    map("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
    map("n", "<leader>q", "vim.lsp.diagnostic.set_loclist()")

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
        map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()")
    elseif client.resolved_capabilities.document_range_formatting then
        map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()")
    end
end

local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
    cmd = {
        "clangd",
        "--background-index",
        "--cross-file-rename",
        "--header-insertion=iwyu",
        "--completion-style=bundled",
        "--malloc-trim"
    },
    on_attach = on_attach,
    filetypes = {"c", "cpp", "cuda", "objc", "objcpp"}
}

lspconfig.sumneko_lua.setup {
    cmd = {
        "lua-language-server"
    },
    on_attach = on_attach,
    settings = {
        Lua = {
	    runtime = {
	        version = "LuaJIT",
            path = vim.split(package.path, ';')
	    },
            diagnostics = {
                globals = {"vim"}
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                }
            },
            telemetry = {
                enable = false
            }
        }
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
