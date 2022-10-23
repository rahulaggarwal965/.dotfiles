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
        use "nvim-lua/plenary.nvim"
        use "lewis6991/impatient.nvim"

        use { "lewis6991/gitsigns.nvim",
            config = function()
                require("plugins.gitsigns")
            end,
        }

        use { "neovim/nvim-lspconfig", module = "lspconfig" }
        use { "ray-x/lsp_signature.nvim", module = "lsp_signature" }

        use { "nvim-lualine/lualine.nvim",
            config = function()
                require("plugins.lualine")
            end
        }

        use { "hrsh7th/nvim-cmp",
            requires =  {
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-path",
                "saadparwaiz1/cmp_luasnip",
                "kdheepak/cmp-latex-symbols",
            },
            config = function()
                require("plugins.cmp")
            end,
        }

        use "L3MON4D3/LuaSnip"
        use { "windwp/nvim-autopairs",
            config = function()
                require("nvim-autopairs").setup()
                local cmp_autopairs = require('nvim-autopairs.completion.cmp')
                require("cmp").event:on( 'confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
            end
        }

        use { "ahmedkhalf/project.nvim",
            config = function()
                require("project_nvim").setup({
                    datapath = vim.fn.stdpath("cache")
                })
            end
        }

        use { "nvim-telescope/telescope.nvim",
            requires = {
                { "nvim-telescope/telescope-fzy-native.nvim" }
            },
            config = function()
                require("plugins.telescope")
            end,
        }

        use { "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
            end,
            keys = "gc"
        }

        use { "mfussenegger/nvim-dap",
            setup = function()
                require("plugins.dap").setup()
            end,
            config = function()
                require("plugins.dap").config()
            end,
            module = 'dap'
        }

        use { "rcarriga/nvim-dap-ui",
            after = "nvim-dap",
            config = function()
                require("dapui").setup()
            end
        }

        use { "mfussenegger/nvim-dap-python", module = "dap-python" }

        use { "nvim-treesitter/nvim-treesitter",
            commit = "4cccb6f",
            config = function()
                require("plugins.treesitter")
            end,
            run = ":TSUpdate"
        }

    	use { "kyazdani42/nvim-tree.lua",
    	    requires = { "kyazdani42/nvim-web-devicons" },
    	    config = function()
    	        require("plugins.tree")
            end
        }

        use {"folke/tokyonight.nvim",
            config = function()
                require("plugins.theme")
            end
        }

        use { "iamcco/markdown-preview.nvim",
            run = function() fn['mkdp#util#install']() end,
            ft = "markdown"
        }

        use { "preservim/vim-markdown" }

        use { "lervag/vimtex", ft = "tex" }

        use { "norcalli/nvim-colorizer.lua",
            cmd = "ColorizerToggle"
        }

        use { "numToStr/Navigator.nvim",
            config = function()
                local navigator = require("Navigator")
                navigator.setup()

                vim.keymap.set("n", "<C-h>", navigator.left)
                vim.keymap.set("n", "<C-j>", navigator.down)
                vim.keymap.set("n", "<C-k>", navigator.up)
                vim.keymap.set("n", "<C-l>", navigator.right)
            end
        }

        use "RyanMillerC/better-vim-tmux-resizer"
    end
)

