return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = { "VeryLazy" },
        lazy = vim.fn.argc(-1) == 0,
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "c",
                    "cpp",
                    "cuda",
                    "go",
                    "lua",
                    "javascript",
                    "python",
                    "bash",
                    "comment",
                    "rust",
                    "yaml",
                    "java",
                    "glsl",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                },
                highlight = { enable = true },
            })
        end
    }
}
