require("lsp").pyright.setup {}

vim.keymap.set("n", "<leader>dm", "<cmd>lua require('dap-python').test_method()<CR>")
vim.keymap.set("n", "<leader>dc", "<cmd>lua require('dap-python').test_class()<CR>")
vim.keymap.set("v", "<leader>ds", "<cmd>lua require('dap-python').debug_selection()<CR>")

require("plugins.dap").external.python = function()
    -- TODO search up the tree to find nearest "debugpy/bin/python" up to n dirs up
    local base = vim.env.VIRTUAL_ENV
    if not base then
        base = "/usr"
    end
    require("dap-python").setup(base .. "/bin/python")
end

