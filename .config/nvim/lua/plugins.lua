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

        use { "lewis6991/gitsigns.nvim",
            requires = { "plenary.nvim" },
            config = function()
                require("plugins.gitsigns")
            end,
        }

        use { "neovim/nvim-lspconfig", module = "lspconfig" }
        use { "ray-x/lsp_signature.nvim", module = "lsp_signature" }
        use { "L3MON4D3/LuaSnip", module = "luasnip" }

        use { "hrsh7th/nvim-cmp",
            requires =  {
                { "hrsh7th/cmp-buffer",       after = "nvim-cmp" },
                { "hrsh7th/cmp-nvim-lsp",     after = "nvim-cmp" },
                { "hrsh7th/cmp-nvim-lua",     after = "nvim-cmp" },
                { "hrsh7th/cmp-path",         after = "nvim-cmp" },
                { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
            },
            config = function()
                require("plugins.cmp")
            end,
            event = "InsertEnter"
        }

        use { "windwp/nvim-autopairs",
            after = "nvim-cmp",
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

        use { "nvim-telescope/telescope.nvim", -- TODO(rahul): this is broken due to some packer bug (telescope doesn't get client automatically)
            requires = {
                { "nvim-telescope/telescope-fzy-native.nvim", opt = true }
            },
            wants = { "telescope-fzy-native.nvim", "plenary.nvim" },
            setup = function()
                require("plugins.telescope").setup()
            end,
            config = function()
                require("plugins.telescope").config()
            end,
            module = "telescope.builtin",
            cmd = "Telescope"
        }

        use { "terrortylor/nvim-comment",
            config = function()
                require("nvim_comment").setup()
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

        -- TODO(rahul): make this based on filetype
        use { "nvim-treesitter/nvim-treesitter",
            config = function()
                require("plugins.treesitter")
            end,
            event = "BufRead",
            run = ":TSUpdate"
        }

    	use { "kyazdani42/nvim-tree.lua",
    	    requires = { "kyazdani42/nvim-web-devicons" },
    	    setup = function()
    	        require("plugins.tree").setup()
            end,
    	    config = function()
    	        require("plugins.tree").config()
            end,
            cmd = "NvimTreeToggle"
        }

        use { "ChristianChiarulli/nvcode-color-schemes.vim",
            event = "ColorSchemePre"
        }

        use { "iamcco/markdown-preview.nvim",
            run = function() fn['mkdp#util#install']() end,
            ft = "markdown"
        }

        use { "plasticboy/vim-markdown" }

        use { "norcalli/nvim-colorizer.lua",
            cmd = "ColorizerToggle"
        }

        use "christoomey/vim-tmux-navigator"
        use "RyanMillerC/better-vim-tmux-resizer"
    end
)

