require("lsp").sumneko_lua.setup {
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
	    runtime = {
	        version = "LuaJIT",
	    },
        diagnostics = {
            globals = { "vim" }
        },
        workspace = {
            library = vim.api.nvim_get_runtime_file("", true)
        },
        telemetry = {
            enable = false
        }
    }
    }
}

vim.cmd "setlocal fo-=ro"
