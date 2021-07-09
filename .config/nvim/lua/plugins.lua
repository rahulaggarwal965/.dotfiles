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
        use { "hrsh7th/nvim-compe",
            config = function()
                require("plugins.compe")
            end,
            event = "InsertEnter"
        }


        use { "lewis6991/gitsigns.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("plugins.gitsigns")
            end,
            event = "BufRead"
        }

        use { "nvim-telescope/telescope.nvim",
            requires = {{ "nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
            config = function()
                require("plugins.telescope")
            end,
            event = "BufEnter"
        }

        use { "terrortylor/nvim-comment",
            config = function()
                require("nvim_comment").setup()
            end,
            event = "BufWinEnter"
        }

        use { "nvim-treesitter/nvim-treesitter",
            config = function()
                require("plugins.treesitter")
            end
        }

    	use { "kyazdani42/nvim-tree.lua",
            commit = "fd7f60e242205ea9efc9649101c81a07d5f458bb",
    	    requires = { "kyazdani42/nvim-web-devicons" },
    	    config = function()
    	        require("plugins.tree")
            end

        }


        use "dstein64/vim-startuptime"
        use "christoomey/vim-tmux-navigator"
        use "RyanMillerC/better-vim-tmux-resizer"
        use "ChristianChiarulli/nvcode-color-schemes.vim"
    end
)
