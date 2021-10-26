require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "cpp", "cuda", "go", "lua", "javascript", "python", "bash", "comment" },
    highlight = { enable = true },
}
