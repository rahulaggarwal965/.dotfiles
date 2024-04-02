local present, theme = pcall(require, "tokyonight")
if not present then
    return
end

theme.setup {
    on_highlights = function(hl, c)
        -- Telescope
        local prompt = "#2d3149"
        hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
        hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopePromptNormal = { bg = prompt }
        hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
        hl.TelescopePromptTitle = { bg = prompt, fg = prompt }
        hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }

        -- NvimTree
        hl.NvimTreeExecFile = { fg = c.green, bold = true }
    end,
    style = "night",
    sidebars = { "qf", "help", "packer" }
}

vim.cmd("colorscheme tokyonight")

