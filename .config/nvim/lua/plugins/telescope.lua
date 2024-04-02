local actions = require("telescope.actions")

require("telescope").setup {
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
                ["<Esc>"] = actions.close,
                ["<C-x>"] = actions.delete_buffer,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous
            }
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        border = true,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true
        }
    }
}

require("telescope").load_extension('fzy_native')

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", function() telescope.find_files({ follow = true }) end, { desc = "List files in current working directory" })

vim.keymap.set("n", "<leader>b", telescope.buffers, { desc = "list current open buffers" })
vim.keymap.set("n", "<leader>/g", telescope.live_grep, { desc = "Search for strings in current working directory" })
vim.keymap.set("n", "<leader>/t", telescope.tags, { desc = "List tags in current working directory" })
vim.keymap.set("n", "<leader>/m", telescope.marks, { desc = "List marks in working session" })
vim.keymap.set("n", "<leader>/r", telescope.registers, { desc = "List current registers" })
vim.keymap.set("n", "<leader>/k", telescope.keymaps, { desc = "List keymappings" })
vim.keymap.set("n", "<leader>/c", telescope.command_history, { desc = "List previous commands" })
vim.keymap.set("n", "<leader>/h", telescope.search_history, { desc = "List previous searches" })
vim.keymap.set("n", "<leader>/s", telescope.current_buffer_fuzzy_find, { desc = "Search within buffer" })
vim.keymap.set("n", "<leader>/w",
    function() require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") }) end,
    { desc = "Search for the word underneath the cursor" })

