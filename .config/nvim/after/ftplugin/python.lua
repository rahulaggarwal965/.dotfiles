require("lsp").pyright.setup({
	on_attach = function(client)
		require("lsp").on_attach(client)
		vim.keymap.set("n", "<leader>lo", ":PyrightOrganizeImports<CR>", { silent = true })
	end,
})
