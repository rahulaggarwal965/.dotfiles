local map = vim.keymap.set

vim.g.mapleader = ' '

-- use jk to escape insert mode
map ("i", "jk", "<Esc>" )

-- hold visual mode when indenting
map ("x", "<", "<gv")
map ("x", ">", ">gv")

-- navigate by visual lines rather than normal lines
map ({"n", "x"}, "j", "gj")
map ({"n", "x"}, "k", "gk")

-- move selected block in visual mode
map ("x", "J", ":m'>+1<CR>='[gv",  { silent = true })
map ("x", "K", ":m '<-2<CR>='[gv", { silent = true })

-- center cursor when moving through search results, but keep counter
map ("n", "n", "nzz<BS>n")
map ("n", "N", "Nzz<Space>N")

-- don't pollute the clipboard with "pasted over" text
map ("x", "p", "pgvy")

-- quickly replay a macro in the q register
map ("n", "Q", "@q")

-- write to files wit elevated permissions
map ("c", "w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!", { silent = true })

-- terminal movement
map ("t", "<Esc><Esc>",  [[<C-\><C-n>]]       )
map ("t", "C-h",         [[<C-\><C-n><C-w>h]] )
map ("t", "C-j",         [[<C-\><C-n><C-w>j]] )
map ("t", "C-k",         [[<C-\><C-n><C-w>k]] )
map ("t", "C-l",         [[<C-\><C-n><C-w>l]] )

map ("n", "<leader>;r", [[:%s//gc<Left><Left><Left>]])
map ("x", "<leader>;r", [[:s/\%V/g<Left><Left>]])
