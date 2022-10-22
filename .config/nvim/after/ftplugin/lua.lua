require("lsp").sumneko_lua.setup {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = { "vim" }
            },
            workspace = {
                vim.fn.expand("$VIMRUNTIME"),
                maxPreload = 5000,
                preloadFileSize = 10000,
            },
            telemetry = { enable = false }
        }
    }
}

vim.cmd "setlocal fo-=ro"
