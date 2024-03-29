local M = {}

M.adapters = {}
M.configurations = {}
M.external = {}

M.setup = function()
    vim.keymap.set("n", "<leader>dd", "<cmd>lua require('dap').continue()<CR>")
    vim.keymap.set("n", "<F4>",  "<cmd>lua require('dap').run_last()<CR>")
    vim.keymap.set("n", "<F5>",  "<cmd>lua require('dap').continue()<CR>")
    vim.keymap.set("n", "<F8>",  "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
    vim.keymap.set("n", "<F9>",  "<cmd>lua require('dap').toggle_breakpoint()<CR>")
    vim.keymap.set("n", "<leader><F9>", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
end

M.config = function()

    local dap = require("dap")
    local api = vim.api

    local ft = vim.bo.filetype

    dap.adapters = M.adapters
    dap.configurations = M.configurations
    if M.external[ft] then
        M.external[ft]()
    end

    local debug_keymaps = {
        ["<F3>" ] = function()
            dap.disconnect()
            dap.close()
            require('dapui').close()
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
            vim.keymap.set("n", lhs, rhs)
        end

        require("dapui").open()
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

        require("dapui").close()
    end
end

return M
