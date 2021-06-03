local o = vim.o
local wo = vim.wo
local bo = vim.bo
local cmd = vim.cmd

o.clipboard = 'unnamedplus'
o.mouse = 'a'
o.showmode = false
o.scrolloff = 5
o.pumheight = 10
o.ignorecase = true
o.smartcase = true
o.termguicolors = true
o.linebreak = true
o.wildmode = 'longest,list,full'
o.hlsearch = false
o.inccommand = 'nosplit'
o.splitbelow = true
o.splitright = true
o.hidden = true
o.updatetime = 100
o.backup = false
o.writebackup = false
cmd [[
    set shortmess+=c
    set fillchars=vert:│
    ]]

wo.conceallevel = 2
wo.number = true
wo.relativenumber = true
wo.breakindent = true
wo.signcolumn = 'yes'

bo.undofile = true
bo.tabstop = 4
bo.shiftwidth = 4
bo.expandtab = true
bo.smartindent = true
bo.copyindent = true
cmd [[
    set iskeyword+=-
    set formatoptions-=ato2
    ]]
