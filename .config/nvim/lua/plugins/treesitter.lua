local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then
    return
end

ts_config.setup {
    ensure_installed = { "c", "cpp", "cuda", "go", "lua", "javascript", "python", "bash", "comment", "rust", "yaml", "java", "glsl", "vim", "vimdoc", "query"},
    highlight = { enable = true },
}

