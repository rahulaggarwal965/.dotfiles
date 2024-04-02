require("lsp").texlab.setup {}

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_mode = 0
vim.opt_local.spell = true
vim.g.vimtex_compiler_latexmk = { out_dir = "build" }
