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

lualine.setup {
    options = {
        theme = "tokyonight",
        component_separators = "",
        section_separators = "",
        disabled_filetypes = {
            statusline = { "NvimTree" }
        }
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            { "b:gitsigns_head", icon = "", color = { gui = "bold" } }
        },
        lualine_c = { "filename", { "diff", source = diff_source } },
        lualine_x = { "diagnostics",
            {
                function()
                    local status = ""
                    local clients = vim.lsp.buf_get_clients()
                    if not next(clients) then
                        return status
                    else
                        local _, client = next(clients)
                        return client.name
                    end
                end,
                color = { gui = "bold" }
            }
        },
        lualine_y = { "filetype",
            {
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
        },
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

