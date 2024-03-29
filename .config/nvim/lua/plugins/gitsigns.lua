local present, gs = pcall(require, "gitsigns")

if not present then
    return
end

gs.setup {
    signs = {
        add          = { hl = 'GitSignsAdd'   , text = '▌', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
        change       = { hl = 'GitSignsChange', text = '▌', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
    },

    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map ("n", "]c", function()
            if vim.wo.diff then return "]c" end
            return ":Gitsigns next_hunk<CR>"
        end, {expr = true})

        map ("n", "[c", function()
            if vim.wo.diff then return "[c" end
            return ":Gitsigns prev_hunk<CR>"
        end, {expr = true})

        --  Actions
        map ({"n", "v"}, "<leader>hs", gs.stage_hunk)
        map ({"n", "v"}, "<leader>hr", gs.reset_hunk)
        map ("n", "<leader>hS", gs.stage_buffer)
        map ("n", "<leader>hu", gs.undo_stage_hunk)
        map ("n", "<leader>hR", gs.reset_buffer)
        map ("n", "<leader>hp", gs.preview_hunk)
        map ("n", "<leader>hb", function() gs.blame_line ({ full = true }) end)
        map ("n", "<leader>tb", gs.toggle_current_line_blame)
        map ("n", "<leader>hd", gs.diffthis)
        map ("n", "<leader>hD", function() gs.diffthis("~") end)
        map ("n", "<leader>td", gs.toggle_deleted)

        --  Text object
        map ({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,

    -- For the dotfiles git bare repo
    worktrees = {
        {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. '/.local/share/.dotfiles'
        }
    }
}
