local present, smart_splits = pcall(require, "smart-splits")

if not present then
    return
end

smart_splits.setup({
    at_edge = "stop"
})

-- Movement
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left,  { desc = "Splits: Move cursor to the window left of the current one" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down,  { desc = "Splits: Move cursor to the window below the current one" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up,    { desc = "Splits: Move cursor to the window above the current one" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Splits: Move cursor to the window right of the current one" })

-- Resizing
vim.keymap.set("n", "<A-h>", smart_splits.resize_left,  { desc = "Splits: Resize the current window to the left" })
vim.keymap.set("n", "<A-j>", smart_splits.resize_down,  { desc = "Splits: Resize the current window downwards" })
vim.keymap.set("n", "<A-k>", smart_splits.resize_up,    { desc = "Splits: Resize the current window upwards" })
vim.keymap.set("n", "<A-l>", smart_splits.resize_right, { desc = "Splits: Resize the current window to the right" })
