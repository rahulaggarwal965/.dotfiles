require("lsp").pyright.setup {}

local nn = vim.keymap.nnoremap
local vn = vim.keymap.vnoremap

nn {"<leader>dm", "<cmd>lua require('dap-python').test_method()<CR>" }
nn {"<leader>dc", "<cmd>lua require('dap-python').test_class()<CR>" }
vn {"<leader>ds", "<cmd>lua require('dap-python').debug_selection()<CR>" }

require("plugins.dap").external.python = function()
    -- TODO search up the tree to find nearest "debugpy/bin/python" up to n dirs up
    local base = os.getenv("VIRTUAL_ENV")
    if not base then
        base = "/usr"
    end
    require("dap-python").setup(base .. "/bin/python")
    -- TODO do pytest/unittest stuff
    require("dap-python").test_runner = "pytest"
end
