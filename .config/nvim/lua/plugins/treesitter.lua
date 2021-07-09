require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "cpp", "cuda" },
    highlight = { enable = true },
}
