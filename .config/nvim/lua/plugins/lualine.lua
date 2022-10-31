local present, lualine = pcall(require, "lualine")

if not present then
    return
end

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
        }
    end
end

local branch = {
    "b:gitsigns_head",
    icon = "",
    color = { gui = "bold" },
    on_click = function()
        require("telescope.builtin").git_branches()
    end
}

local lsp = {
    function()
        local status = ""
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        if not next(clients) then
            return status
        else
            local _, client = next(clients)
            return client.name
        end
    end,
    color = { gui = "bold" },
    on_click = function()
        require("lspconfig.ui.lspinfo")()
    end
}

local python_env = {
    function()
        local version = ""
        require("plenary.job"):new({
            command = "python",
            args = { "--version" },
            on_stdout = function(_, data)
                if data then
                    version = vim.split(data, " ")[2]
                end
            end
        }):sync()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv then
            return string.format("%s (%s)", version, vim.fs.basename(venv))
        end
        return version
    end,
    padding = { left = 0, right = 1 },
    cond = function() return vim.bo.filetype == "python" end
}

lualine.setup {
    options = {
        theme = "tokyonight",
        component_separators = "",
        section_separators = "",
        ignore_focus = { "TelescopePrompt", "NvimTree", "lspinfo", "packer" },
        disabled_filetypes = {
            statusline = { "NvimTree", "packer" }
        }
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { branch },
        lualine_c = { "filename", { "diff", source = diff_source } },
        lualine_x = { "diagnostics", lsp },
        lualine_y = { "filetype", python_env },
        lualine_z = { "location" }

    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {}
    }
}

