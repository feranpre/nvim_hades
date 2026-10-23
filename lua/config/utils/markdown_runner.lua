local chunks = require("config.utils.chunks")
local runner = require("config.utils.code_runner")

local M = {}

local function current_chunk()
	local chunk = chunks.at_cursor()

	if not chunk then
		vim.notify("No code block found under cursor", vim.log.levels.WARN)
	end

	return chunk
end

local function send_chunks(language, list)
	if #list == 0 then
		vim.notify("No " .. language .. " code blocks", vim.log.levels.WARN)
		return
	end

	for _, chunk in ipairs(list) do
		runner.send(language, chunk.code)
	end
end

-- Ejecuta el bloque bajo el cursor
function M.run_cell()
	local chunk = current_chunk()

	if chunk then
		runner.send(chunk.language, chunk.code)
	end
end

-- Ejecuta el bloque y salta a la línea siguiente al cierre
function M.run_cell_and_move()
	local chunk = current_chunk()

	if not chunk then
		return
	end

	runner.send(chunk.language, chunk.code)

	local target = math.min(chunk.end_row + 2, vim.api.nvim_buf_line_count(0))
	vim.api.nvim_win_set_cursor(0, { target, 0 })
end

-- Ejecuta la línea actual con el lenguaje del bloque
function M.run_line(language)
	runner.send(language, vim.api.nvim_get_current_line())
end

-- Ejecuta la selección visual con el lenguaje del bloque
function M.run_selection(language)
	local start_row = vim.fn.line("v")
	local end_row = vim.fn.line(".")

	if start_row > end_row then
		start_row, end_row = end_row, start_row
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)

	runner.send(language, table.concat(lines, "\n"))
end

-- Ejecuta todos los bloques del lenguaje hasta el actual (incluido)
function M.run_above(language)
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1

	send_chunks(language, chunks.all(0, language, row))
end

-- Ejecuta todos los bloques del lenguaje del documento
function M.run_all(language)
	send_chunks(language, chunks.all(0, language))
end

return M
