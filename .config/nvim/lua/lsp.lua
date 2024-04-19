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

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, desc = "LSP: Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = true, desc = "LSP: Go to declaration" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = true, desc = "LSP: Go to implementation" })
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = true, desc = "LSP: Go to type definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true, desc = "LSP: Go to references" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true, desc = "LSP: Show definition" })
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, { buffer = true, desc = "LSP: Rename symbol" })
    vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { buffer = true, desc = "LSP: Rename Symbol" })
    vim.keymap.set({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { buffer = true, desc = "LSP: Code Action" })

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = true, desc = "LSP: Previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = true, desc = "LSP: Next diagnostic" })
    vim.keymap.set("n", "<leader>lc", function() vim.diagnostic.hide(nil, 0) end, { buffer = true, desc = "LSP: Clear diagnostics" })
    vim.keymap.set("n", "<leader>ll", vim.diagnostic.open_float, { buffer = true, desc = "LSP: Show line diagnostics" })
    vim.keymap.set("n", "<leader>lQ", vim.diagnostic.setloclist, { buffer = true, desc = "LSP: Add diagnostics to quickfix list" })
    vim.keymap.set("n", "<leader>lx", ":LspStop<CR>", { silent = true, desc = "LSP: Start LSP" })
    vim.keymap.set("n", "<leader>lX", ":LspStart<CR>", { silent = true, desc = "LSP: Stop LSP" })

    local telescope = require("telescope.builtin")
    vim.keymap.set("n", "<leader>lr", telescope.lsp_references, { buffer = true, desc = "Search: references for symbol" })
    vim.keymap.set("n", "<leader>ld", telescope.lsp_definitions, { buffer = true, desc = "Search: definitions for symbol" })
    vim.keymap.set("n", "<leader>li", telescope.lsp_implementations, { buffer = true, desc = "Search: implementations for symbols" })
    vim.keymap.set("n", "<leader>ls", telescope.lsp_document_symbols, { buffer = true, desc = "Search: file symbols" })
    vim.keymap.set("n", "<leader>lS", telescope.lsp_dynamic_workspace_symbols, { buffer = true, desc = "Search: project symbols" })
    vim.keymap.set("n", "<leader>lg", function() telescope.diagnostics({ bufnr = 0 }) end, { buffer = true, desc = "Search: project diagnostics" })
    vim.keymap.set("n", "<leader>lG", telescope.diagnostics, { buffer = true, desc = "Search: project diagnostics" })

    if client.server_capabilities.document_formatting then
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({async = true}) end, { buffer = true, desc = "LSP: Format document"})
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

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = "", texthl = "DiagnosticSignWarn",  numhl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = "", texthl = "DiagnosticSignInfo",  numhl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",  { text = "", texthl = "DiagnosticSignHint",  numhl = "DiagnosticSignHint" })

M.configured_servers = {}

local meta = {
    __index = function(_, server_name)

        -- We do not want to setup the server everytime we enter a new file
        for _, configured_server_name in pairs(M.configured_servers) do
            if (server_name == configured_server_name) then
                return { setup = function() end }
            end
        end
        table.insert(M.configured_servers, server_name)

        return {
            setup = function(config)

                local cmd
                if (config.cmd == nil) then
                    cmd = require("lspconfig.server_configurations." .. server_name).default_config.cmd
                else
                    cmd = config.cmd
                end

                if (vim.fn.executable(cmd[1]) == 0) then
                    return
                end

                if config.on_attach == nil then
                    config.on_attach = M.on_attach
                end
                config.capabilities = M.capabilities

                local lspconfig = require("lspconfig")
                lspconfig[server_name].setup(config)
                lspconfig[server_name].manager:try_add_wrapper(vim.api.nvim_get_current_buf()) --so we can use this in ftplugins
            end
        }
    end
}

setmetatable(M, meta)

return M

