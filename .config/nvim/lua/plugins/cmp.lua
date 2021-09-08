local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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
   TypeParameter = "",
}

local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup {
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
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
         behavior = cmp.ConfirmBehavior.Replace,
         select = true,
      },
      ["<Tab>"] = function(fallback)
         if vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t("<C-n>"), "n")
         elseif luasnip.expand_or_jumpable() then
            vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
         else
            fallback()
         end
      end,
      ["<S-Tab>"] = function(fallback)
         if vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t("<C-p>"), "n")
         elseif luasnip.jumpable(-1) then
            vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
         else
            fallback()
         end
      end
   },
   sources = {
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer" },
      { name = "nvim_lua" }
   }
}
