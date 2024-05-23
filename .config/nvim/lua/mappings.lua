vim.g.mapleader = ' '
-- use jk to escape insert mode
vim.keymap.set("i", "jk", "<Esc>")

-- hold visual mode when indenting
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- navigate by visual lines rather than normal lines
vim.keymap.set({"n", "x"}, "j", "gj")
vim.keymap.set({"n", "x"}, "k", "gk")

-- move selected block in visual mode
vim.keymap.set("x", "J", ":m'>+1<CR>='[gv",  { silent = true })
vim.keymap.set("x", "K", ":m '<-2<CR>='[gv", { silent = true })

-- center cursor when moving through search results, but keep counter
vim.keymap.set("n", "n", "nzz<BS>n")
vim.keymap.set("n", "N", "Nzz<Space>N")

-- don't pollute the clipboard with "pasted over" text
vim.keymap.set("x", "p", "pgvy")

-- write to files wit elevated permissions
vim.keymap.set("c", "w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!", { silent = true })

-- terminal movement
vim.keymap.set("t", "<Esc><Esc>",  [[<C-\><C-n>]]       )
vim.keymap.set("t", "C-h",         [[<C-\><C-n><C-w>h]] )
vim.keymap.set("t", "C-j",         [[<C-\><C-n><C-w>j]] )
vim.keymap.set("t", "C-k",         [[<C-\><C-n><C-w>k]] )
vim.keymap.set("t", "C-l",         [[<C-\><C-n><C-w>l]] )

vim.keymap.set("n", "<leader>;r", [[:%s//gc<Left><Left><Left>]])
vim.keymap.set("x", "<leader>;r", [[:s/\%V/g<Left><Left>]])
