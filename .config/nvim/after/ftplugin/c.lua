require("lsp").clangd.setup {
    cmd = {
        "clangd",
        "--background-index",
        "--cross-file-rename",
        "--header-insertion=iwyu",
        "--completion-style=bundled",
        "--malloc-trim"
    },
    on_attach = function(client)
        require("lsp").on_attach(client)
        vim.keymap.nnoremap { "gh", ":ClangdSwitchSourceHeader<CR>", silent = true }
    end,
    filetypes = {"c", "cpp", "cuda", "objc", "objcpp"}
}

-- This is important to resolve symlinked filetypes
local ft = vim.bo.filetype

require("plugins.dap").adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",
    name = "lldb"
}

require("plugins.dap").configurations[ft] = {
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

vim.cmd("setlocal fo-=ro")
