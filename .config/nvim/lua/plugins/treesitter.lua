require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "cpp", "cuda", "go", "lua", "python", "bash", "comment" },
    highlight = { enable = true },
}
