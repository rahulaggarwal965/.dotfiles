return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                mappings = {
                    i = {
                        ["<Esc>"] = require("telescope.actions").close,
                        ["<C-x>"] = require("telescope.actions").delete_buffer,
                        ["<C-s>"] = require("telescope.actions").select_horizontal,
                        ["<C-j>"] = require("telescope.actions").move_selection_next,
                        ["<C-k>"] = require("telescope.actions").move_selection_previous,
                    },
                },
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns = {},
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display = { "truncate" },
                border = true,
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                use_less = true,
                set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

                -- Developer configurations: Not meant for general override
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
            },
            extensions = {
                fzy_nativef = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
            },
        },
        keys = {
            {
                "<leader>f",
                function() require("telescope.builtin").find_files({ follow = true }) end,
                desc = "Search: files in current working directory",
            },
            {
                "<leader>b",
                function() require("telescope.builtin").buffers() end,
                desc = "Search: current open buffers",
            },
            {
                "<leader>/g",
                function() require("telescope.builtin").live_grep() end,
                desc = "Search: words in current working directory",
            },
            {
                "<leader>/t",
                function() require("telescope.builtin").tags() end,
                desc = "Search: tags in current working directory",
            },
            {
                "<leader>/m",
                function() require("telescope.builtin").marks() end,
                desc = "Search: marks in working session",
            },
            {
                "<leader>/r",
                function() require("telescope.builtin").registers() end,
                desc = "Search: current registers",
            },
            {
                "<leader>/k",
                function() require("telescope.builtin").keymaps() end,
                desc = "Search: keymappings",
            },
            {
                "<leader>/c",
                function() require("telescope.builtin").command_history() end,
                desc = "Search: previous commands",
            },
            {
                "<leader>/h",
                function() require("telescope.builtin").search_history() end,
                desc = "Search: previous searches",
            },
            {
                "<leader>/s",
                function() require("telescope.builtin").current_buffer_fuzzy_find() end,
                desc = "Search: words within buffer",
            },
            {
                "<leader>/w",
                function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") }) end,
                desc = "Search: word underneath the cursor",
            },
        },
    },
}
