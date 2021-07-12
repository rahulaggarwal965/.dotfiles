local ino = vim.keymap.inoremap
local nn = vim.keymap.nnoremap
local xn = vim.keymap.xnoremap
local cn = vim.keymap.cnoremap
local tn = vim.keymap.tnoremap

vim.g.mapleader = ' '

-- use jk to escape insert mode
ino { "jk", "<Esc>" }

-- hold visual mode when indenting
xn { "<", "<gv" }
xn { ">", ">gv" }

-- copy to end of line
nn { "Y", "y$" }

-- navigate by visual lines rather than normal lines
nn { "j", "gj" }
nn { "k", "gk" }
xn { "j", "gj" }
xn { "k", "gk" }

-- move selected block in visual mode
xn { 'J', ":m'>+1<CR>='[gv",  silent = true }
xn { 'K', ":m '<-2<CR>='[gv", silent = true }

-- don't pollute the clipboard with "pasted over" text
xn { "p", "pgvy" }

-- quickly replay a macro in the q register
nn { "Q", "@q" }

-- write to files wit elevated permissions
cn { 'w!!', "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!", silent = true }

-- terminal movement
tn { "<Esc>", [[<C-\><C-n>]] }
tn { "jk",    [[<C-\><C-n>]] }
tn { "C-h",   [[<C-\><C-n><C-w>h]] }
tn { "C-j",   [[<C-\><C-n><C-w>j]] }
tn { "C-k",   [[<C-\><C-n><C-w>k]] }
tn { "C-l",   [[<C-\><C-n><C-w>l]] }

-- n          <leader>;r :%s//gc<Left><Left><Left>
-- n          <leader>;f m`gg=G``
-- x          <leader>;r :s/\%V/g<Left><Left>
-- n          <leader>;x :!chmod +x %<CR>
