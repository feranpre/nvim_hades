local M = {}

local function get_code_block()
	local parser = vim.treesitter.get_parser(0, "markdown")

	if not parser then
		return nil
	end

	local tree = parser:parse()[1]
	local root = tree:root()

	local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

	local query = vim.treesitter.query.parse(
		"markdown",
		[[
			(fenced_code_block) @block
		]]
	)

	for _, node in query:iter_captures(root, 0, 0, -1) do
		local start_row, _, end_row, _ = node:range()

		if cursor_row >= start_row and cursor_row < end_row then
			local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)

			if #lines < 3 then
				return nil
			end

			local info = lines[1]

			local language = info:match("^%s*```%s*{%s*([^,}]+)") or info:match("^%s*```%s*([%w_+-]+)")

			if not language then
				return nil
			end

			language = vim.trim(language):lower()

			table.remove(lines, 1)
			table.remove(lines, #lines)

			return {
				language = language,
				content = table.concat(lines, "\n"),
			}
		end
	end

	return nil
end

function M.run_cell()
	local block = get_code_block()

	if not block then
		vim.notify("No code block found under cursor", vim.log.levels.WARN)
		return
	end

	require("config.utils.code_runner").send(block.language, block.content)
end

return M
