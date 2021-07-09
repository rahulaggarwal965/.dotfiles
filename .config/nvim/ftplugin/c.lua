require("lspconfig").clangd.setup {
    cmd = {
        "clangd",
        "--background-index",
        "--cross-file-rename",
        "--header-insertion=iwyu",
        "--completion-style=bundled",
        "--malloc-trim"
    },
    on_attach = require("lsp").on_attach,
    filetypes = {"c", "cpp", "cuda", "objc", "objcpp"}
}
