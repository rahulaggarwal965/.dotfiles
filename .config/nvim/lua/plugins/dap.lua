local M = {}

M.mappings = function()
    local nn = vim.keymap.nnoremap
    nn { "<leader>dd", "<cmd>lua require('dap').continue()<CR>" }
    nn { "<F8>",  "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>" }
    nn { "<F9>",  "<cmd>lua require('dap').toggle_breakpoint()<CR>" }
    nn { "<leader><F9> ", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" }
end

M.config = function()

    local dap = require("dap")
    print(dap)

    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb"
    }

    dap.configurations.c = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            args = function()
                return vim.split(vim.fn.input('Arguments: '), ' ', true)
            end,
        }
    }

dap.configurations.cpp = dap.configurations.c
    local nn = vim.keymap.nnoremap
    local api = vim.api

    local debug_keymaps = {
        ["<F3>" ] = function()
            dap.disconnect()
            dap.stop()
        end,
        ["<F4>" ] = "<cmd>lua require('dap').run_last()<CR>",
        ["<F5>" ] = "<cmd>lua require('dap').continue()<CR>",
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
