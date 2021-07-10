require("lspconfig").clangd.setup {
    cmd = {
        "clangd",
        "--background-index",
        "--cross-file-rename",
        "--header-insertion=iwyu",
        "--completion-style=bundled",
        "--malloc-trim"
    },
    on_attach = function(client)
        require("lsp").on_attach(client)
        vim.keymap.nnoremap { "gh", ":ClangdSwitchSourceHeader<CR>", silent = true }
    end,
    capabilities = require("lsp").capabilities,
    filetypes = {"c", "cpp", "cuda", "objc", "objcpp"}
}
