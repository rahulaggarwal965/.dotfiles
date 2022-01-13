local M = {}

local telescope_map = function (key, f, buffer)
    local mode = "n"
    local rhs = string.format(":Telescope %s<CR>", f)

    local map_options = {
       noremap = true,
       silent = true,
    }

    if not buffer then
        vim.api.nvim_set_keymap(mode, key, rhs, map_options)
    else
        vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
    end
end

M.telescope_map = telescope_map

M.setup = function()
    telescope_map("<leader>f",  "find_files") -- list files in current working directory
    telescope_map("<leader>b",  "buffers") -- list current open buffers
    telescope_map("<leader>/g", "live_grep") -- search for strings in current working directory
    telescope_map("<leader>/t", "tags") -- list tags in current working directory
    telescope_map("<leader>/m", "marks") -- list marks in working session
    telescope_map("<leader>/r", "registers") -- list current registers
    telescope_map("<leader>/k", "keymaps") -- list keymappings
    telescope_map("<leader>/c", "command_history") -- list previous commands
    telescope_map("<leader>/h", "search_history") -- list previous searches
    telescope_map("<leader>/s", "current_buffer_fuzzy_find") -- search within buffer
    vim.keymap.set("n", "<leader>/w", function() require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") }) end ) -- Search for the word underneath the cursor



end

M.config = function()
    local actions = require("telescope.actions")

    require('telescope').setup{
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case'
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "flex",
        layout_config = {
          horizontal = { mirror = false },
          vertical = { mirror = false },
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
        file_sorter =  require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
        path_display = { "shorten" },
        winblend = 10,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,

        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                orverride_file_sorter = true
            }
        }
      }
    }

    require("telescope").load_extension('fzy_native')
end

return M
