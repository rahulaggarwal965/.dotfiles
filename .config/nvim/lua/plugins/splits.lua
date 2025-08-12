return {
    {
        "mrjones2014/smart-splits.nvim",
        opts = {
            at_edge = "stop",
        },
        keys = {
            {
                "<C-h>",
                function() require("smart-splits").move_cursor_left() end,
                { desc = "Splits: Move cursor to the window left of the current one" },
            },
            {
                "<C-j>",
                function() require("smart-splits").move_cursor_down() end,
                { desc = "Splits: Move cursor to the window below the current one" },
            },
            {
                "<C-k>",
                function() require("smart-splits").move_cursor_up() end,
                { desc = "Splits: Move cursor to the window above the current one" },
            },
            {
                "<C-l>",
                function() require("smart-splits").move_cursor_right() end,
                { desc = "Splits: Move cursor to the window right of the current one" },
            },

            -- Resizing
            {
                "<A-h>",
                function() require("smart-splits").resize_left() end,
                { desc = "Splits: Resize the current window to the left" },
            },
            {
                "<A-j>",
                function() require("smart-splits").resize_down() end,
                { desc = "Splits: Resize the current window downwards" },
            },
            {
                "<A-k>",
                function() require("smart-splits").resize_up() end,
                { desc = "Splits: Resize the current window upwards" },
            },
            {
                "<A-l>",
                function() require("smart-splits").resize_right() end,
                { desc = "Splits: Resize the current window to the right" },
            },
        },
    },
}
