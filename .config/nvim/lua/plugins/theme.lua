local present, theme = pcall(require, "tokyonight")
if not present then
    return
end

theme.setup {
    style = "night",
    sidebars = { "qf", "help", "packer" }
}

vim.cmd("colorscheme tokyonight")

