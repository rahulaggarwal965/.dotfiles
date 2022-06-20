local M = {}

M.setup = function()
    vim.keymap.set ("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
end

M.config = function()

    local tree_cb = require'nvim-tree.config'.nvim_tree_callback
    require("nvim-tree").setup {
        update_cwd = true,
        respect_buf_cwd = true,
        diagnostics = {
            enable = true,
            icons = {
                hint    = "",
                info    = "",
                warning = "",
                error   = "",
            }
        },
        update_focused_file = {
            enable = true,
            update_cwd = true
        },
        view = {
            mappings = {
                list = {
                  { key = "l",      cb = tree_cb("edit") },
                  { key = "L",      cb = tree_cb("cd") },
                  { key = "H",      cb = tree_cb("dir_up") },
                  { key = "<C-s>",  cb = tree_cb("split") },
                  { key = "h",      cb = tree_cb("close_node") },
                  { key = ".",      cb = tree_cb("toggle_dotfiles") },
                }
            }
        },
        renderer = {
            highlight_git = true,
            icons = {
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        default      = "",
                        open         = "",
                        empty        = "",
                        empty_open   = "",
                        symlink      = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged  = "",
                        staged    = "S",
                        unmerged  = "",
                        renamed   = "->",
                        untracked = "U",
                        deleted   = "-",
                        ignored   = "~",
                    },
                }
            },
            special_files = {
                "README.md",
                "LICENSE",
                "Makefile"
            }
        },
        actions = {
            open_file = {
                quit_on_open = true
            }
        }
    }

    vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")
end

return M
