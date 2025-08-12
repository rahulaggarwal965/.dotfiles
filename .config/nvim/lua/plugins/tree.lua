return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            -- Auto close nvim-tree when it is the last buffer
            vim.api.nvim_create_autocmd("BufEnter", {
                nested = true,
                callback = function()
                    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then vim.cmd("quit") end
                end,
            })

            return {
                diagnostics = {
                    enable = true,
                    icons = {
                        hint = "",
                        info = "",
                        warning = "",
                        error = "",
                    },
                },
                update_focused_file = {
                    enable = true,
                },
                on_attach = function(bufnr)
                    local api = require("nvim-tree.api")
                    api.config.mappings.default_on_attach(bufnr)

                    vim.keymap.set("n", "l", api.node.open.edit, { buffer = bufnr, desc = "File Explorer: Open file" })
                    vim.keymap.set("n", "L", api.tree.change_root_to_node, { buffer = bufnr, desc = "File Explorer: cd down" })
                    vim.keymap.set("n", "H", api.tree.change_root_to_parent, { buffer = bufnr, desc = "File Explorer: cd up" })
                    vim.keymap.set(
                        "n",
                        "<C-s>",
                        api.node.open.horizontal,
                        { buffer = bufnr, desc = "File Explorer: Open file in horizontal split" }
                    )
                    vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = bufnr, desc = "File Explorer: Close node" })
                    vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, { buffer = bufnr, desc = "File Explorer: Toggle hidden files" })
                end,
                renderer = {
                    highlight_git = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                        glyphs = {
                            default = "",
                            symlink = "",
                            folder = {
                                default = "",
                                open = "",
                                empty = "",
                                empty_open = "",
                                symlink = "",
                                symlink_open = "",
                            },
                            git = {
                                unstaged = "",
                                staged = "S",
                                unmerged = "",
                                renamed = "->",
                                untracked = "U",
                                deleted = "-",
                                ignored = "~",
                            },
                        },
                    },
                    special_files = {
                        "README.md",
                        "LICENSE",
                        "Makefile",
                    },
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
            }
        end,
        keys = {
            {
                "<leader>e",
                function() require("nvim-tree.api").tree.toggle() end,
                desc = "File Explorer: Toggle",
            },
        },
    },
}
