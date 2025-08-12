require("lsp").clangd.setup({
	cmd = {
		"clangd",
		"--background-index",
		"--header-insertion=iwyu",
		"--completion-style=bundled",
		"--malloc-trim",
	},
	on_attach = function(client)
		require("lsp").on_attach(client)
		vim.keymap.set("n", "gh", ":ClangdSwitchSourceHeader<CR>", { silent = true })
	end,
	filetypes = { "c", "cpp", "cuda", "objc", "objcpp" },
})

vim.cmd("setlocal fo-=ro")
