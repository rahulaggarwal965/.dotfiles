local icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "kdheepak/cmp-latex-symbols",
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = function(entry, item)
                        item.kind = icons[item.kind]

                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            path     = "[Path]",
                            buffer   = "[Buf]",
                            nvim_lua = "[Lua]",
                        })[entry.source.name]

                        return item
                    end
                },
                mapping = {
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm {
                       behavior = cmp.ConfirmBehavior.Replace,
                       select = false,
                    },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                           cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                           fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                           fallback()
                        end
                    end, { "i", "s", })
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp"      },
                    { name = "path"          },
                    { name = "luasnip"       },
                    { name = "nvim_lua"      },
                    { name = "latex_symbols" }
                },{
                    { name = "buffer"        },
                }),
                experimental = {
                    ghost_text = true
                }
            }
        end
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "nvim-cmp" },
        opts = {
            history = true,
            delete_check_events = "TextChanged"
        }
    }
}
