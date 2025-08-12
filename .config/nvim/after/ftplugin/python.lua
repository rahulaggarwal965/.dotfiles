local function uv_script_interpreter(script_path)
	local result = vim.system({ "uv", "python", "find", "--script", script_path }, { text = true }):wait()
	if result.code == 0 then
		return vim.fn.trim(result.stdout)
	end
end

local function uv_interpreter(script_path)
	local result = vim.system({ "uv", "python", "find" }, { text = true }):wait()
	if result.code == 0 then
		return vim.fn.trim(result.stdout)
	end
end

require("lsp").pyright.setup({
	before_init = function(_, config)
		local script = vim.api.nvim_buf_get_name(0)
		local python = uv_script_interpreter(script)
		if not python then
			python = uv_interpreter(script)
		end
		config.settings.python.pythonPath = python
	end,
	on_attach = function(client)
		require("lsp").on_attach(client)
		vim.keymap.set("n", "<leader>lo", ":PyrightOrganizeImports<CR>", { silent = true })
	end,
})

vim.keymap.set("n", "<leader>lp", function()
	local yank = vim.fn.getreg("+")
	yank = yank:gsub('"', '\\"')

	-- Get current line's indentation
	local current_line = vim.api.nvim_get_current_line()
	local indent = current_line:match("^(%s*)") or ""

	-- Create the line with the same indentation
	local line = indent .. string.format('print(f"{%s = }")', yank)

	-- Insert the line below the current one
	vim.api.nvim_put({ line }, "l", true, true)
end, { desc = "Insert Python f-string debug print of last yank with indentation" })
