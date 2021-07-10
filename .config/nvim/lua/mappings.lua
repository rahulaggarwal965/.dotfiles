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

nn { "<F3>",  "<cmd>lua require('dap').stop()<CR>" }
nn { "<F4>",  "<cmd>lua require('dap').run_last()<CR>" }
nn { "<F5>",  "<cmd>lua require('dap').continue()<CR>" }
nn { "<F6>",  "<cmd>lua require('dap').pause()<CR>" }
nn { "<F10>", "<cmd>lua require('dap').step_over()<CR>" }
nn { "<F11>", "<cmd>lua require('dap').step_into()<CR>" }
nn { "<F12>", "<cmd>lua require('dap').step_out()<CR>" }

nn { "<leader><F8>", "<cmd>lua require('dap').run_to_cursor()<CR>" }
nn { "<leader>dd", "<cmd>lua require('dap').continue()<CR>" }
nn { "<F9>",  "<cmd>lua require('dap').toggle_breakpoint()<CR>" }
nn { "<leader><F9> ", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" }

-- n          <leader>;r :%s//gc<Left><Left><Left>
-- n          <leader>;f m`gg=G``
-- x          <leader>;r :s/\%V/g<Left><Left>
-- n          <leader>;x :!chmod +x %<CR>
