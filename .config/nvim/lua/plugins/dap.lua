local M = {}

M.adapter = {}
M.configurations = {}

M.mappings = function()
    local nn = vim.keymap.nnoremap
    nn { "<leader>dd", "<cmd>lua require('dap').continue()<CR>" }
    nn { "<F4>",  "<cmd>lua require('dap').run_last()<CR>" }
    nn { "<F5>",  "<cmd>lua require('dap').continue()<CR>" }
    nn { "<F8>",  "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>" }
    nn { "<F9>",  "<cmd>lua require('dap').toggle_breakpoint()<CR>" }
    nn { "<leader><F9> ", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" }
end

M.config = function()

    local dap = require("dap")
    local api = vim.api

    local ft = api.nvim_buf_get_option(0, 'filetype')

    if (M.adapter.name ~= nil) then
        dap.adapters[M.adapter.name] = M.adapter
        dap.configurations[ft] = M.configurations
    end

    local nn = vim.keymap.nnoremap

    local debug_keymaps = {
        ["<F3>" ] = function()
            dap.disconnect()
            dap.stop()
        end,
        ["<F6>" ] = "<cmd>lua require('dap').pause()<CR>",
        ["<F7>" ] = "<cmd>lua require('dap').run_to_cursor()<CR>",
        ["<F10>"] = "<cmd>lua require('dap').step_over()<CR>",
        ["<F11>"] = "<cmd>lua require('dap').step_into()<CR>",
        ["<F12>"] = "<cmd>lua require('dap').step_out()<CR>",
        ["K"    ] = "<cmd>lua require('dapui').eval()<CR>"
    }

    local keymap_restore = {}

    dap.listeners.after['event_initialized']['me'] = function()
        for _, buf in pairs(api.nvim_list_bufs()) do
            local keymaps = api.nvim_buf_get_keymap(buf, 'n')
            for _, keymap in pairs(keymaps) do
                if keymap.lhs == "K" then
                    table.insert(keymap_restore, keymap)
                    api.nvim_buf_del_keymap(buf, 'n', 'K')
                end
            end
        end

        for lhs, rhs in pairs(debug_keymaps) do
            nn { lhs, rhs }
        end
    end

    dap.listeners.after['event_terminated']['me'] = function()
        for lhs, _ in pairs(debug_keymaps) do
            api.nvim_del_keymap( 'n', lhs )
        end
        for _, keymap in pairs(keymap_restore) do
            api.nvim_buf_set_keymap(
            keymap.buffer,
            keymap.mode,
            keymap.lhs,
            keymap.rhs,
            { silent = keymap.silent == 1 })
        end
        keymap_restore = {}
    end
end

return M
