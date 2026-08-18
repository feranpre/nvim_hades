local M = {}

local function send_range(start_line, end_line)
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	if #lines == 0 then
		return
	end

	local code = table.concat(lines, "\n")

	require("r.send").cmd(code)
end

local function current_line()
	local row = vim.api.nvim_win_get_cursor(0)[1]

	send_range(row, row)
end

local function paragraph()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local start = row
	local finish = row

	while start > 1 and lines[start - 1] ~= "" do
		start = start - 1
	end

	while finish < #lines and lines[finish + 1] ~= "" do
		finish = finish + 1
	end

	send_range(start, finish)
end

local function quarto_chunk()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local start = nil
	local finish = nil

	for i = row, 1, -1 do
		if lines[i]:match("^%s*```%s*%b{}") then
			start = i + 1
			break
		end

		if lines[i]:match("^%s*```%s*$") then
			return false
		end
	end

	if not start then
		return false
	end

	for i = row, #lines do
		if lines[i]:match("^%s*```%s*$") then
			finish = i - 1
			break
		end
	end

	if not finish then
		return false
	end

	send_range(start, finish)

	return true
end

---------------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------------

local function get_node_at_cursor()
	local ok, node = pcall(vim.treesitter.get_node)

	if not ok then
		return nil
	end

	return node
end

local function find_function_node(node)
	while node do
		local type = node:type()

		-- R Treesitter parser uses this node for function definitions.
		if type == "function_definition" then
			return node
		end

		node = node:parent()
	end

	return nil
end

local function function_range()
	local node = get_node_at_cursor()

	if not node then
		return false
	end

	local func = find_function_node(node)

	if not func then
		return false
	end

	local start_row, _, end_row, _ = func:range()

	-- Treesitter uses zero-based rows.
	send_range(start_row + 1, end_row + 1)

	return true
end

---------------------------------------------------------------------------
-- Smart execution
---------------------------------------------------------------------------

function M.smart()
	local ft = vim.bo.filetype

	-----------------------------------------------------------------------
	-- Quarto / R Markdown
	-----------------------------------------------------------------------

	if ft == "quarto" or ft == "rmd" then
		if quarto_chunk() then
			return
		end
	end

	-----------------------------------------------------------------------
	-- R function
	-----------------------------------------------------------------------

	if ft == "r" then
		if function_range() then
			return
		end

		paragraph()

		return
	end

	-----------------------------------------------------------------------
	-- Fallback
	-----------------------------------------------------------------------

	current_line()
end

return M
