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

        use "wbthomason/packer.nvim"
        use "tjdevries/astronauta.nvim"

        use "neovim/nvim-lspconfig"
        use "ray-x/lsp_signature.nvim"
        use "hrsh7th/nvim-compe"


        use { "lewis6991/gitsigns.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("gitsigns").setup()
            end
        }

        use { "nvim-telescope/telescope.nvim",
            requires = {{ "nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
        }

        use { "terrortylor/nvim-comment",
            config = function()
                require("nvim_comment").setup()
            end
        }

        use { "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate"
        }

    	use { "kyazdani42/nvim-tree.lua",
            commit = "fd7f60e242205ea9efc9649101c81a07d5f458bb",
    	    requires = { "kyazdani42/nvim-web-devicons" },
        }


        use "dstein64/vim-startuptime"
        use "christoomey/vim-tmux-navigator"
        use "RyanMillerC/better-vim-tmux-resizer"
        use "ChristianChiarulli/nvcode-color-schemes.vim"
    end
)
