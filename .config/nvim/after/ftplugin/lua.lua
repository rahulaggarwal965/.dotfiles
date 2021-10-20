require("lspconfig").sumneko_lua.setup {
    cmd = {
        "lua-language-server"
    },
    on_attach = require("lsp").on_attach,
    capabilities = require("lsp").capabilities,
    settings = {
        Lua = {
	    runtime = {
	        version = "LuaJIT",
            path = vim.split(package.path, ';')
	    },
            diagnostics = {
                globals = { "vim" }
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

require("lspconfig").sumneko_lua.manager.try_add_wrapper()

vim.cmd "setlocal fo-=ro"
