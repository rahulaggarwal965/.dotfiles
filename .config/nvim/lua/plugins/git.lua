return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "▌" },
                change = { text = "▌" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            numhl = true,
            linehl = false,

            on_attach = function(bufnr)
                local gs = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, { desc = "Git: Go to next change" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, { desc = "Git: Go to previous change" })

                --  Actions
                map("n", "<leader>hs", gs.stage_hunk, { desc = "Git: Stage hunk under cursor" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Git: Reset hunk under cursor" })
                map(
                    "v",
                    "<leader>hs",
                    function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { desc = "Git: Stage selected range" }
                )
                map(
                    "v",
                    "<leader>hr",
                    function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { desc = "Git: Reset selected range" }
                )
                map("n", "<leader>hS", gs.stage_buffer, { desc = "Git: Stage buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Git: Unstage last hunk" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "Git: Reset buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Git: Show hunk diff under cursor" })
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Git: Show current line blame" })
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Git: Toggle current line blame" })
                map("n", "<leader>hd", gs.diffthis, { desc = "Git: Diff working tree against HEAD" })
                map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Git: diff working tree against HEAD~" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "Git: Toggle inline deleted hunks" })

                --  Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: select hunk" })
            end,

            -- For the dotfiles git bare repo
            worktrees = {
                {
                    toplevel = vim.env.HOME,
                    gitdir = vim.env.HOME .. "/.local/share/.dotfiles",
                },
            },
        },
    },
}
