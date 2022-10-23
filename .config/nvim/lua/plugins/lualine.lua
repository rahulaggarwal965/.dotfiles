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
        lualine_a = {"mode"},
        lualine_b = {
            {"b:gitsigns_head", icon = "", color = {gui = "bold"}}
        },
        lualine_c = {"filename", {"diff", source = diff_source}},
        lualine_x = {"diagnostics", "filetype"},
        lualine_y = {},
        lualine_z = {"location"}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {}
    }
}
