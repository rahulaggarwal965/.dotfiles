require('compe').setup {
    enabled          = true,
    autocomplete     = true,
    debug            = false,
    min_length       = 1,
    preselect        = "enable",
    throttle_time    = 80,
    source_timeout   = 200,
    incomplete_delay = 400,
    max_abbr_width   = 100,
    max_kind_width   = 100,
    max_menu_width   = 100,
    documentation    = true,

    source = {
        path = true,
        buffer = {
            enable = true,
            priority = 1
        },
        nvim_lsp = {
            enable = true,
            priority = 9999
        },
        nvim_lua = true
    }
}

local imap = vim.keymap.imap
local smap = vim.keymap.smap
local inoremap = vim.keymap.inoremap

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    else
        return t "<Tab>"
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    else
        return t "<S-Tab>"
    end
end

imap { "<Tab>", "v:lua.tab_complete()", expr = true }
smap { "<Tab>", "v:lua.tab_complete()", expr = true }
imap { "<S-Tab>", "v:lua.s_tab_complete()", expr = true }
smap { "<S-Tab>", "v:lua.s_tab_complete()", expr = true }
inoremap { "<CR>", "compe#confirm('<CR>')", expr = true }
