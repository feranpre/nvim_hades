-- Bloques de código (```lang ... ``` o ```{lang} ... ```) en markdown
local M = {}

-- Lenguajes ejecutables y sus alias en la cabecera del bloque
local ALIASES = {
	r = "r",
	python = "python",
	py = "python",
	bash = "bash",
	sh = "bash",
	shell = "bash",
}

-- Normaliza la cabecera de un bloque: "```{r, echo=FALSE}" -> "r"
function M.language(info)
	local language = info:match("^%s*```+%s*{%s*([^,}%s]+)") or info:match("^%s*```+%s*([%w_+-]+)")

	if not language then
		return nil
	end

	return ALIASES[language:lower()]
end

local function fenced_blocks(buf)
	local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")

	if not ok or not parser then
		return nil
	end

	local root = parser:parse()[1]:root()
	local query = vim.treesitter.query.parse("markdown", "(fenced_code_block) @block")

	local blocks = {}

	for _, node in query:iter_captures(root, buf, 0, -1) do
		local start_row, _, end_row, end_col = node:range()

		-- El rango del nodo termina en la columna 0 de la línea siguiente
		if end_col == 0 then
			end_row = end_row - 1
		end

		table.insert(blocks, { start_row = start_row, end_row = end_row })
	end

	return blocks
end

local function make_chunk(buf, block)
	local lines = vim.api.nvim_buf_get_lines(buf, block.start_row, block.end_row + 1, false)

	if #lines < 2 or not lines[#lines]:match("^%s*```") then
		return nil
	end

	local language = M.language(lines[1])

	if not language then
		return nil
	end

	return {
		language = language,
		-- Filas 0-indexadas de las vallas de apertura y cierre
		start_row = block.start_row,
		end_row = block.end_row,
		code = table.concat(lines, "\n", 2, #lines - 1),
	}
end

-- Bloque ejecutable bajo el cursor (o nil)
function M.at_cursor(buf, row)
	buf = buf or vim.api.nvim_get_current_buf()
	row = row or vim.api.nvim_win_get_cursor(0)[1] - 1

	for _, block in ipairs(fenced_blocks(buf) or {}) do
		if row >= block.start_row and row <= block.end_row then
			return make_chunk(buf, block)
		end
	end

	return nil
end

-- Todos los bloques ejecutables de un lenguaje, opcionalmente hasta una fila
function M.all(buf, language, until_row)
	buf = buf or vim.api.nvim_get_current_buf()

	local chunks = {}

	for _, block in ipairs(fenced_blocks(buf) or {}) do
		if until_row and block.start_row > until_row then
			break
		end

		local chunk = make_chunk(buf, block)

		if chunk and chunk.language == language then
			table.insert(chunks, chunk)
		end
	end

	return chunks
end

return M
