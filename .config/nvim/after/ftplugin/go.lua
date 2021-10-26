require("lspconfig").gopls.setup {
    on_attach = function(client)
        require("lsp").on_attach(client)
    end,
    capabilities = require("lsp").capabilities
}

require("lspconfig").gopls.manager.try_add_wrapper()