-- r_send.lua
local M = {}

local function send_range(start_line, end_line)
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	if #lines == 0 then
		return
	end

	local code = table.concat(lines, "\n")

	require("r.send").cmd(code)
end

local function move_cursor_after(end_line)
	local last_line = vim.api.nvim_buf_line_count(0)
	local target = math.min(end_line + 1, last_line)
	vim.api.nvim_win_set_cursor(0, { target, 0 })
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

	return finish
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

	-- +1 para saltar el ``` de cierre.
	return finish + 1
end

---------------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------------

local function is_blank(line)
	return line == nil or line:match("^%s*$") ~= nil
end

-- Encuentra el "parrafo" de statements de nivel superior bajo el cursor:
-- junta hermanos consecutivos mientras NO haya una linea en blanco real
-- entre ellos. Si el statement es un bloque (for/if/function/while), sus
-- lineas en blanco internas no cuentan como separador porque son un unico
-- nodo, no varios hermanos.
local function block_range()
	local parser = vim.treesitter.get_parser(0, "r")

	if not parser then
		return false
	end

	local tree = parser:parse()[1]
	local root = tree:root()

	local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

	local children = {}

	for child in root:iter_children() do
		if child:named() then
			table.insert(children, child)
		end
	end

	local idx = nil

	for i, child in ipairs(children) do
		local start_row, _, end_row, _ = child:range()

		if cursor_row >= start_row and cursor_row <= end_row then
			idx = i
			break
		end
	end

	if not idx then
		return false
	end

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local function gap_has_blank(end_row_a, start_row_b)
		for row = end_row_a + 1, start_row_b - 1 do
			if is_blank(lines[row + 1]) then
				return true
			end
		end

		return false
	end

	local start_idx = idx
	local finish_idx = idx

	while start_idx > 1 do
		local prev_end_row = select(3, children[start_idx - 1]:range())
		local cur_start_row = select(1, children[start_idx]:range())

		if gap_has_blank(prev_end_row, cur_start_row) then
			break
		end

		start_idx = start_idx - 1
	end

	while finish_idx < #children do
		local cur_end_row = select(3, children[finish_idx]:range())
		local next_start_row = select(1, children[finish_idx + 1]:range())

		if gap_has_blank(cur_end_row, next_start_row) then
			break
		end

		finish_idx = finish_idx + 1
	end

	local start_row = select(1, children[start_idx]:range())
	local end_row = select(3, children[finish_idx]:range())

	send_range(start_row + 1, end_row + 1)

	return end_row + 1
end

---------------------------------------------------------------------------
-- Ejecutar solo la linea (S-Enter)
---------------------------------------------------------------------------
function M.line()
	local row = vim.api.nvim_win_get_cursor(0)[1]

	current_line()
	move_cursor_after(row)
end

---------------------------------------------------------------------------
-- Ejecutar bloque y bajar cursor (C-Enter)
---------------------------------------------------------------------------
function M.smart()
	local ft = vim.bo.filetype
	local end_line = nil

	if ft == "quarto" or ft == "rmd" then
		end_line = quarto_chunk()

		if end_line then
			move_cursor_after(end_line)
			return
		end
	end

	if ft == "r" then
		end_line = block_range()

		if end_line then
			move_cursor_after(end_line)
			return
		end

		end_line = paragraph()
		move_cursor_after(end_line)

		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	current_line()
	move_cursor_after(row)
end

return M
