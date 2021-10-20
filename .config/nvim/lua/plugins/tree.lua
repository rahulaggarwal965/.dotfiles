local M = {}

M.mappings = function()
    vim.keymap.nnoremap { '<leader>e', ":NvimTreeToggle<CR>", silent = true }
end

M.config = function()

    local g = vim.g

    g.nvim_tree_quit_on_open = 1
    g.nvim_tree_gitignore = 1
    g.nvim_tree_git_hl = 1
    g.nvim_tree_respect_buf_cwd = 1

    g.nvim_tree_show_icons = {
        git = 1,
        folders = 1,
        files = 1,
        folder_arrows = 1,
        lsp = 1
    }

    g.vim_tree_special_files = {
        "README.md",
        "LICENSE",
        "Makefile"
    }

    g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged    = "",
            staged      = "S",
            unmerged    = "",
            renamed     = "->",
            untracked   = "U",
            deleted     = "-",
            ignored     = "~",
        },
        folder = {
            default         = "",
            open            = "",
            empty           = "",
            empty_open      = "",
            symlink         = "",
            symlink_open    = "",
        },
        lsp = {
            error   = "",
            warning = "",
            info    = "",
            hint    = "",
        },
    }

    local tree_cb = require'nvim-tree.config'.nvim_tree_callback
    require("nvim-tree").setup {
        auto_close = true,
        update_cwd = true,
        diagnostics = {
            enable = true,
            icons = {
                error   = "",
                warning = "",
                info    = "",
                hint    = ""
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
        }
    }
end

return M
