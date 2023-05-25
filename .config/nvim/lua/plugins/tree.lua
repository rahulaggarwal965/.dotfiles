local tree = require("nvim-tree")
local api = require("nvim-tree.api")

tree.setup {
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
    },
    on_attach = function(bufnr)
        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "l", api.node.open.edit, { buffer = bufnr })
        vim.keymap.set("n", "L", api.tree.change_root_to_node, { buffer = bufnr })
        vim.keymap.set("n", "H", api.tree.change_root_to_parent, { buffer = bufnr })
        vim.keymap.set("n", "<C-s>", api.node.open.horizontal, { buffer = bufnr })
        vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = bufnr })
        vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, { buffer = bufnr })
    end,
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

vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle File Explorer" })

-- Auto close nvim-tree when it is the last buffer
vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
            vim.cmd "quit"
        end
    end
})

