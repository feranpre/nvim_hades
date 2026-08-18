local M = {}

local fold_nodes = {
	["function_definition"] = true,
	["braced_expression"] = true,
	["if_statement"] = true,
	["for_statement"] = true,
	["while_statement"] = true,
	["repeat_statement"] = true,
}

local function get_fold_level(lnum)
	local parser = vim.treesitter.get_parser(0, vim.bo.filetype)

	if not parser then
		return 0
	end

	local tree = parser:parse()[1]

	if not tree then
		return 0
	end

	local root = tree:root()
	local line = lnum - 1

	local node = root:named_descendant_for_range(line, 0, line, vim.api.nvim_buf_line_count(0))

	local level = 0

	while node do
		if fold_nodes[node:type()] then
			local start_row, _, end_row, _ = node:range()

			if line >= start_row and line < end_row then
				level = level + 1
			end
		end

		node = node:parent()
	end

	return level
end

function M.foldexpr(lnum)
	return get_fold_level(lnum)
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"r",
			"rmd",
			"quarto",
			"python",
			"lua",
			"javascript",
			"typescript",
			"c",
			"cpp",
			"rust",
			"bash",
		},

		callback = function()
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.require('config.folding').foldexpr(v:lnum)"
			vim.wo.foldenable = true
			vim.wo.foldlevel = 99
		end,
	})
end

return M
