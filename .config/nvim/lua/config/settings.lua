local opt = vim.opt

vim.cmd([[colorscheme tokyonight]])
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.showmode = false
opt.scrolloff = 5
opt.pumheight = 10
opt.completeopt = { "menuone", "noselect" }
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.linebreak = true
opt.wildmode = { "longest", "full" }
opt.hlsearch = false
opt.inccommand = "nosplit"
opt.splitbelow = true
opt.splitright = true
opt.hidden = true
opt.updatetime = 500
opt.lazyredraw = true
opt.backup = false
opt.writebackup = false
opt.fillchars = { vert = "│", eob = " " }
opt.shortmess:append("c")

opt.conceallevel = 2
opt.foldlevelstart = 20
opt.number = true
opt.relativenumber = true
opt.breakindent = true
opt.showbreak = string.rep(" ", 3)
opt.signcolumn = "yes"

opt.undofile = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.copyindent = true
opt.formatoptions:remove("atro2")
opt.iskeyword:append("-")
