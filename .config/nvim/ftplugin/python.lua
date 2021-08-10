require("lspconfig").pyright.setup {
    on_attach = function(client)
        require("lsp").on_attach(client)
    end,
    capabilities = require("lsp").capabilities
}


require("plugins.dap").adapters.python = {
    type = "executable",
    command = "/usr/bin/python",
    args = { "-m", "debugpy.adapter" }
}

require("plugins.dap").configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",

        program = "${file}",
        pythonPath = "/usr/bin/python"
    }
}
