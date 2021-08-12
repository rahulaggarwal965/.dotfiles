local M = {}

M.mappings = function()
    local nn = vim.keymap.nnoremap
    nn { '<leader>f',  function() require('telescope.builtin').find_files()                 end } -- list files in current working directory
    nn { '<leader>b',  function() require('telescope.builtin').buffers()                    end } -- list current open buffers
    nn { '<leader>/g', function() require('telescope.builtin').live_grep()                  end } -- search for strings in current working directory
    nn { '<leader>/t', function() require('telescope.builtin').tags()                       end } -- list tags in current working directory
    nn { '<leader>/m', function() require('telescope.builtin').marks()                      end } -- list marks in working session
    nn { '<leader>/r', function() require('telescope.builtin').registers()                  end } -- list current registers
    nn { '<leader>/k', function() require('telescope.builtin').keymaps()                    end } -- list keymappings
    nn { '<leader>/c', function() require('telescope.builtin').command_history()            end } -- list previous commands
    nn { '<leader>/h', function() require('telescope.builtin').search_history()             end } -- list previous searches
    nn { '<leader>/s', function() require('telescope.builtin').current_buffer_fuzzy_find()  end } -- search within buffer
    nn { '<leader>/w', function() require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") }) end } -- Search for the word underneath the cursor
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
          horizontal = {
            mirror = false,
          },
          vertical = {
            mirror = false,
          },
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
