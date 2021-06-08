local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

local packer = require('packer')

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

return packer.startup(function(use)


        use 'wbthomason/packer.nvim'

        use 'neovim/nvim-lspconfig'
        use 'hrsh7th/nvim-compe'
        require('plugins.lspconfig')
        require('plugins.compe')
    end
)
