local set_keymap = vim.api.nvim_set_keymap

vim.g.mapleader = ' '

set_keymap('i', 'jk', '<Esc>', {noremap = true, silent = true})

set_keymap('x', '<', '<gv', {noremap = true, silent = true})
set_keymap('x', '>', '>gv', {noremap = true, silent = true})

set_keymap('n', 'Y', 'y$', {noremap = true, silent = true})

set_keymap('n', 'j', 'gj', {noremap = true, silent = true})
set_keymap('n', 'k', 'gk', {noremap = true, silent = true})
set_keymap('x', 'j', 'gj', {noremap = true, silent = true})
set_keymap('x', 'k', 'gk', {noremap = true, silent = true})

set_keymap('x', 'J', ':m \'>+1<CR>gv=gv', {noremap = true, silent = true})
set_keymap('x', 'K', ':m \'<-2<CR>gv=gv', {noremap = true, silent = true})

set_keymap('c', 'w!!', 'execute \'silent! write !sudo tee % >/dev/null\' <bar> edit!', {noremap = true, silent = true})

-- n          <leader>;r :%s//gc<Left><Left><Left>
-- n          <leader>;f m`gg=G``
-- x          <leader>;r :s/\%V/g<Left><Left>
-- n          <leader>;x :!chmod +x %<CR>
