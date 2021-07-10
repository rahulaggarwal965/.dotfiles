local ino = vim.keymap.inoremap
local nn = vim.keymap.nnoremap
local xn = vim.keymap.xnoremap
local cn = vim.keymap.cnoremap

vim.g.mapleader = ' '

-- use jk to escape insert mode
ino { 'jk', '<Esc>' }

-- hold visual mode when indenting
xn { '<', '<gv' }
xn { '>', '>gv' }

-- copy to end of line
nn { 'Y', 'y$' }

-- navigate by visual lines rather than normal lines
nn { 'j', 'gj' }
nn { 'k', 'gk' }
xn { 'j', 'gj' }
xn { 'k', 'gk' }

-- move selected block in visual mode
xn { 'J', ":m \'>+1<CR>gv=gv", silent = true }
xn { 'K', ":m \'<-2<CR>gv=gv", silent = true }

-- write to files wit elevated permissions
cn { 'w!!', "execute \'silent! write !sudo tee % >/dev/null\' <bar> edit!", silent = true }

-- Telescope mappings
nn { '<leader>f',  function() require('telescope.builtin').find_files() end }                -- list files in current working directory
nn { '<leader>b',  function() require('telescope.builtin').buffers() end }                   -- list current open buffers
nn { '<leader>/g', function() require('telescope.builtin').live_grep() end }                 -- search for strings in current working directory
nn { '<leader>/t', function() require('telescope.builtin').tags() end}                       -- list tags in current working directory
nn { '<leader>/m', function() require('telescope.builtin').marks() end }                     -- list marks in working session
nn { '<leader>/k', function() require('telescope.builtin').keymaps() end }                   -- list keymappings
nn { '<leader>/c', function() require('telescope.builtin').command_history() end }           -- list previous commands
nn { '<leader>/h', function() require('telescope.builtin').search_history() end }            -- list previous searches
nn { '<leader>/s', function() require('telescope.builtin').current_buffer_fuzzy_find() end } -- search within buffer

vim.keymap.nnoremap { '<leader>e', ":NvimTreeToggle<CR>", silent = true }
-- n          <leader>;r :%s//gc<Left><Left><Left>
-- n          <leader>;f m`gg=G``
-- x          <leader>;r :s/\%V/g<Left><Left>
-- n          <leader>;x :!chmod +x %<CR>
