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
local t = require("telescope.builtin")
nn { '<leader>f', t.find_files }            -- list files in current working directory
nn { '<leader>b', t.buffers }               -- list current open buffers
nn { '<leader>/g', t.live_grep }            -- search for strings in current working directory
nn { '<leader>/t', t.tags }                 -- list tags in current working directory
nn { '<leader>/m', t.marks }                -- list marks in working session
nn { '<leader>/k', t.keymaps }              -- list keymappings
nn { '<leader>/c', t.command_history }      -- list previous commands
nn { '<leader>/h', t.search_history }       -- list previous searches

-- File Explorer
nn { '<leader>e', function() require('nvim-tree').toggle() end }



-- n          <leader>;r :%s//gc<Left><Left><Left>
-- n          <leader>;f m`gg=G``
-- x          <leader>;r :s/\%V/g<Left><Left>
-- n          <leader>;x :!chmod +x %<CR>
