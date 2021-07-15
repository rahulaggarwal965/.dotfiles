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
        use { "ray-x/lsp_signature.nvim",
            module = "lsp_signature"
        }
        use { "hrsh7th/nvim-compe",
            config = function()
                require("plugins.compe")
            end,
            event = "InsertEnter"
        }
        use { "L3MON4D3/LuaSnip",
            module = "luasnip"
        }
        use { "windwp/nvim-autopairs",
            after = "nvim-compe",
            config = function()
                require("nvim-autopairs").setup()
                require("nvim-autopairs.completion.compe").setup({
                    map_cr = true,
                    map_complete = true
                })
            end
        }

        use { "lewis6991/gitsigns.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("plugins.gitsigns")
            end,
            event = "BufRead"
        }

        use { "nvim-telescope/telescope.nvim",
            requires = {
                { "nvim-lua/popup.nvim" },
                { "nvim-lua/plenary.nvim" },
                { "nvim-telescope/telescope-fzy-native.nvim" }
            },
            setup = function()
                require("plugins.telescope").mappings()
            end,
            config = function()
                require("plugins.telescope").config()
            end,
            module = "telescope.builtin"
        }

        use { "terrortylor/nvim-comment",
            config = function()
                require("nvim_comment").setup()
            end,
            event = "BufWinEnter"
        }

        use { "mfussenegger/nvim-dap",
            setup = function()
                require("plugins.dap").mappings()
            end,
            config = function()
                require("plugins.dap").config()
            end,
            module = 'dap'
        }

        use { "rcarriga/nvim-dap-ui",
            after = "nvim-dap",
        }

        -- TODO(rahul): make this based on filetype
        use { "nvim-treesitter/nvim-treesitter",
            config = function()
                require("plugins.treesitter")
            end,
            run = ":TSUpdate"
        }

    	use { "kyazdani42/nvim-tree.lua",
            commit = "fd7f60e242205ea9efc9649101c81a07d5f458bb",
    	    requires = { "kyazdani42/nvim-web-devicons" },
    	    setup = function()
    	        require("plugins.tree").mappings()
            end,
    	    config = function()
    	        require("plugins.tree").config()
            end,
            cmd = "NvimTreeToggle"
        }

        use "christoomey/vim-tmux-navigator"
        use "RyanMillerC/better-vim-tmux-resizer"
        use "ChristianChiarulli/nvcode-color-schemes.vim"
    end
)
