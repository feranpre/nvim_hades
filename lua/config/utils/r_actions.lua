-- Code actions propias para R, para lo que el LSP de R no resuelve.
--
-- Se sirven con un servidor LSP "en proceso" (hades_r, sin programa externo),
-- así salen en el menú normal de code actions (<leader>la / gra) junto a las
-- del resto de servidores.
--
-- Funcionan en .R y, en Quarto / R Markdown, dentro de los bloques ```{r}.
--
--   * line_length_linter (lintr): parte la línea larga
--       - comentario de línea completa  -> se reparte en varias líneas
--       - comentario al final           -> se sube encima de la línea
--       - cadena de pipes (|> o %>%)    -> un paso por línea
--       - llamada f(a, b, c)            -> un argumento por línea
--     y repite con las líneas que salen hasta que caben (o no se puede más).
--   * brace_linter ("Any function spanning multiple lines should use curly
--     braces"): añade { } al cuerpo de la función.
--
-- Cada una tiene versión para la línea/función del cursor y para todo el
-- archivo. El ancho se lee del .lintr del proyecto (line_length_linter(120));
-- sin .lintr, 80 (valor por defecto de lintr).

local M = {}

local DEFAULT_LIMIT = 80
local PIPES = {
	["|>"] = true,
	["%>%"] = true,
}

---------------------------------------------------------------------------
-- Utilidades
---------------------------------------------------------------------------

local function width(s)
	return vim.fn.strchars(s)
end

local function leading(s)
	return s:match("^%s*")
end

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

--- Ancho máximo de línea según el .lintr más cercano
function M.line_limit(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	local dir = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
	local lintr = vim.fs.find(".lintr", { path = dir, upward = true, type = "file" })[1]

	if lintr then
		local ok, lines = pcall(vim.fn.readfile, lintr)
		if ok then
			local text = table.concat(lines, "\n")
			local n = text:match("line_length_linter%s*%(%s*(%d+)")
				or text:match("line_length_linter%s*%(%s*length%s*=%s*(%d+)")
			if n then
				return tonumber(n)
			end
		end
	end

	return DEFAULT_LIMIT
end

local function indent_unit(bufnr)
	if vim.bo[bufnr].filetype ~= "r" then
		return "  "
	end
	local sw = vim.bo[bufnr].shiftwidth
	if sw == 0 then
		sw = vim.bo[bufnr].tabstop
	end
	return string.rep(" ", sw > 0 and sw or 2)
end

---------------------------------------------------------------------------
-- Zonas con código R
---------------------------------------------------------------------------

--- Filas (0-based, inclusivas) con código R: todo el archivo en .R; en
--- Quarto / R Markdown, el interior de los bloques ```{r ...}
---@return {first: integer, last: integer}[]
function M.r_regions(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	if vim.bo[bufnr].filetype == "r" then
		return { { first = 0, last = #lines - 1 } }
	end

	local regions, start = {}, nil
	for i, line in ipairs(lines) do
		local row = i - 1
		if not start then
			if line:match("^%s*```+%s*{%s*[rR]%s*[,}]") or line:match("^%s*```+%s*{%s*[rR]%s+") then
				start = row + 1
			end
		elseif line:match("^%s*```+%s*$") then
			if row - 1 >= start then
				table.insert(regions, { first = start, last = row - 1 })
			end
			start = nil
		end
	end
	return regions
end

---------------------------------------------------------------------------
-- Partir líneas largas
---------------------------------------------------------------------------

local function parse_line(text)
	local ok, parser = pcall(vim.treesitter.get_string_parser, text, "r")
	if not ok then
		return nil
	end
	local tree = parser:parse()[1]
	return tree and tree:root()
end

local function walk(node, fn)
	fn(node)
	for child in node:iter_children() do
		walk(child, fn)
	end
end

local function is_pipe(node, text)
	if node:type() ~= "binary_operator" then
		return false
	end
	local op = node:field("operator")[1]
	return op ~= nil and PIPES[vim.treesitter.get_node_text(op, text)] == true
end

-- Comentario de línea completa: reparto por palabras
local function wrap_comment(text, limit)
	local prefix, body = text:match("^(%s*#+'?%s*)(.*)$")
	if not prefix or body == "" then
		return nil
	end

	local out, current = {}, prefix
	for word in body:gmatch("%S+") do
		if current ~= prefix and width(current) + 1 + width(word) > limit then
			table.insert(out, current)
			current = prefix .. word
		elseif current == prefix then
			current = prefix .. word
		else
			current = current .. " " .. word
		end
	end
	table.insert(out, current)

	return #out > 1 and out or nil
end

-- Comentario al final de una línea de código: se sube encima
local function hoist_comment(text, root)
	local comment
	walk(root, function(node)
		if not comment and node:type() == "comment" then
			comment = node
		end
	end)
	if not comment then
		return nil
	end

	local _, col = comment:start()
	local code = text:sub(1, col):gsub("%s+$", "")
	if trim(code) == "" then
		return nil
	end

	return { leading(text) .. vim.treesitter.get_node_text(comment, text), code }
end

-- Cadena de pipes: un paso por línea
local function split_pipes(text, root, unit)
	local outer
	walk(root, function(node)
		if not outer and is_pipe(node, text) and not node:has_error() then
			outer = node
		end
	end)
	if not outer then
		return nil
	end

	-- La cadena es asociativa por la izquierda: a |> b |> c = ((a |> b) |> c)
	local cuts = {}
	local node = outer
	while node and is_pipe(node, text) do
		local _, _, _, op_end = node:field("operator")[1]:range()
		table.insert(cuts, 1, op_end)
		node = node:field("lhs")[1]
	end

	local lead = leading(text)
	local out, from = {}, 1
	for i, cut in ipairs(cuts) do
		local piece = text:sub(from, cut)
		table.insert(out, i == 1 and piece:gsub("%s+$", "") or lead .. unit .. trim(piece))
		from = cut + 1
	end
	table.insert(out, lead .. unit .. trim(text:sub(from)))

	return out
end

-- Llamada (o definición de función): un argumento por línea
local function split_arguments(text, root, unit)
	local best
	walk(root, function(node)
		local t = node:type()
		if (t == "arguments" or t == "parameters") and not node:has_error() then
			local _, col = node:start()
			-- Solo llamadas con "(" (no `x[i, ]`) y sin argumentos vacíos
			-- (`f(a, , b)`), que se perderían al repartirlos
			local items, commas = 0, 0
			for child in node:iter_children() do
				local ct = child:type()
				if ct == "argument" or ct == "parameter" then
					items = items + 1
				elseif ct == "comma" then
					commas = commas + 1
				end
			end
			local opens_paren = node:child(0) and node:child(0):type() == "("
			if opens_paren and items > 0 and commas == items - 1 and (not best or col < select(2, best:start())) then
				best = node
			end
		end
	end)
	if not best then
		return nil
	end

	local lead = leading(text)
	local _, _, _, close_end = best:range()

	-- Texto hasta el paréntesis de apertura incluido
	local first = best:child(0)
	local _, _, _, open_end = first:range()
	local last = best:child(best:child_count() - 1)
	local _, close_start = last:start()

	local out = { text:sub(1, open_end) }
	local items = {}
	for child in best:iter_children() do
		local t = child:type()
		if t == "argument" or t == "parameter" then
			table.insert(items, vim.treesitter.get_node_text(child, text))
		end
	end
	for i, item in ipairs(items) do
		table.insert(out, lead .. unit .. trim(item) .. (i < #items and "," or ""))
	end
	table.insert(out, lead .. text:sub(close_start + 1, close_end) .. text:sub(close_end + 1))

	return out
end

--- Parte `text` en varias líneas de como mucho `limit` caracteres (si puede)
---@return string[]
function M.break_line(text, limit, unit, depth)
	depth = depth or 0
	if width(text) <= limit or depth > 20 then
		return { text }
	end

	local pieces
	if text:match("^%s*#") then
		pieces = wrap_comment(text, limit)
	else
		local root = parse_line(text)
		if root then
			pieces = hoist_comment(text, root) or split_pipes(text, root, unit) or split_arguments(text, root, unit)
		end
	end

	if not pieces or #pieces < 2 then
		return { text }
	end

	local out = {}
	for _, piece in ipairs(pieces) do
		vim.list_extend(out, M.break_line(piece, limit, unit, depth + 1))
	end
	return out
end

-- Edición LSP que sustituye la línea `row` (0-based) por `lines`
local function line_edit(row, lines)
	return {
		range = {
			start = { line = row, character = 0 },
			["end"] = { line = row + 1, character = 0 },
		},
		newText = table.concat(lines, "\n") .. "\n",
	}
end

local function long_line_edits(bufnr, regions, first, last)
	local limit = M.line_limit(bufnr)
	local unit = indent_unit(bufnr)
	local edits = {}

	for _, region in ipairs(regions) do
		local from, to = math.max(first, region.first), math.min(last, region.last)
		if from <= to then
			local lines = vim.api.nvim_buf_get_lines(bufnr, from, to + 1, false)
			for i, text in ipairs(lines) do
				-- `#| opción: valor` (opciones de bloque de Quarto) no se tocan
				if width(text) > limit and not text:match("^%s*#|") then
					local new = M.break_line(text, limit, unit)
					if #new > 1 then
						table.insert(edits, line_edit(from + i - 1, new))
					end
				end
			end
		end
	end

	return edits, limit
end

---------------------------------------------------------------------------
-- Llaves en funciones de varias líneas
---------------------------------------------------------------------------

-- Funciones de varias líneas cuyo cuerpo no va entre { }. Cada zona de
-- código R se analiza por separado; `offset` es su primera fila en el buffer.
---@return {node: TSNode, offset: integer}[]
local function unbraced_functions(bufnr, regions)
	local found = {}

	for _, region in ipairs(regions) do
		local lines = vim.api.nvim_buf_get_lines(bufnr, region.first, region.last + 1, false)
		local root = parse_line(table.concat(lines, "\n"))
		if root then
			walk(root, function(node)
				if node:type() == "function_definition" then
					local body = node:field("body")[1]
					local start_row, _, end_row = node:range()
					if body and body:type() ~= "braced_expression" and start_row ~= end_row and not body:has_error() then
						table.insert(found, { node = node, offset = region.first })
					end
				end
			end)
		end
	end

	return found
end

local function fn_range(f)
	local s, _, e = f.node:range()
	return s + f.offset, e + f.offset
end

local function brace_edits(bufnr, f, unit)
	local fn, offset = f.node, f.offset
	local params = fn:field("parameters")[1]
	local body = fn:field("body")[1]
	if not params or not body then
		return nil
	end

	local fn_row = fn:start() + offset
	local lead = leading(vim.api.nvim_buf_get_lines(bufnr, fn_row, fn_row + 1, false)[1] or "")

	local _, _, p_row, p_col = params:range()
	local b_row, b_col, e_row, e_col = body:range()
	p_row, b_row, e_row = p_row + offset, b_row + offset, e_row + offset

	-- Si detrás del cuerpo solo queda un comentario, la llave va al final
	-- de la línea para no dejar el comentario detrás de "}"
	local end_line = vim.api.nvim_buf_get_lines(bufnr, e_row, e_row + 1, false)[1] or ""
	if end_line:sub(e_col + 1):match("^%s*#") then
		e_col = #end_line
	end

	local open = {
		range = {
			start = { line = p_row, character = p_col },
			["end"] = { line = b_row, character = b_col },
		},
		newText = " {\n" .. (b_row == p_row and lead .. unit or leading(vim.api.nvim_buf_get_lines(bufnr, b_row, b_row + 1, false)[1] or "")),
	}

	local close = {
		range = {
			start = { line = e_row, character = e_col },
			["end"] = { line = e_row, character = e_col },
		},
		newText = "\n" .. lead .. "}",
	}

	return { open, close }
end

---------------------------------------------------------------------------
-- Code actions
---------------------------------------------------------------------------

local function action(title, uri, edits)
	return {
		title = title,
		kind = "quickfix",
		edit = { changes = { [uri] = edits } },
	}
end

function M.code_actions(bufnr, uri, range)
	local actions = {}
	local unit = indent_unit(bufnr)
	local row_first, row_last = range.start.line, range["end"].line
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	local regions = M.r_regions(bufnr)
	if #regions == 0 then
		return actions
	end

	-- Líneas largas
	local here, limit = long_line_edits(bufnr, regions, row_first, math.min(row_last, line_count - 1))
	if #here > 0 then
		local what = #here == 1 and "la línea" or (#here .. " líneas")
		table.insert(actions, action(("R: partir %s (más de %d caracteres)"):format(what, limit), uri, here))
	end

	local all = long_line_edits(bufnr, regions, 0, line_count - 1)
	if #all > #here then
		table.insert(actions, action(("R: partir todas las líneas largas del archivo (%d)"):format(#all), uri, all))
	end

	-- Funciones sin llaves
	local funcs = unbraced_functions(bufnr, regions)
	if #funcs > 0 then
		-- La más interior que contenga el cursor
		local inner
		for _, f in ipairs(funcs) do
			local s, e = fn_range(f)
			if s <= row_first and e >= row_first then
				if not inner or s >= fn_range(inner) then
					inner = f
				end
			end
		end

		if inner then
			local edits = brace_edits(bufnr, inner, unit)
			if edits then
				table.insert(actions, action("R: añadir { } a la función", uri, edits))
			end
		end

		if #funcs > (inner and 1 or 0) then
			-- Funciones anidadas pueden cerrar en el mismo punto: la llave de
			-- la interior tiene que ir antes, así que se procesan de dentro a
			-- fuera (las interiores aparecen después en el recorrido)
			local edits = {}
			for i = #funcs, 1, -1 do
				vim.list_extend(edits, brace_edits(bufnr, funcs[i], unit) or {})
			end
			table.insert(
				actions,
				action(("R: añadir { } a todas las funciones de varias líneas (%d)"):format(#funcs), uri, edits)
			)
		end
	end

	return actions
end

---------------------------------------------------------------------------
-- Servidor LSP en proceso
---------------------------------------------------------------------------

local function server(dispatchers)
	local closing = false
	local next_id = 0

	return {
		request = function(method, params, callback)
			next_id = next_id + 1
			local result, err

			if method == "initialize" then
				result = {
					capabilities = {
						codeActionProvider = { codeActionKinds = { "quickfix" } },
						positionEncoding = "utf-8",
					},
					serverInfo = { name = "hades_r" },
				}
			elseif method == "textDocument/codeAction" then
				local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
				local ok, res = pcall(M.code_actions, bufnr, params.textDocument.uri, params.range)
				if ok then
					result = res
				else
					err = { code = -32603, message = tostring(res) }
				end
			elseif method == "shutdown" then
				result = vim.NIL
			end

			vim.schedule(function()
				callback(err, result)
			end)
			return true, next_id
		end,

		notify = function(method)
			if method == "exit" then
				closing = true
				dispatchers.on_exit(0, 15)
			end
			return true
		end,

		is_closing = function()
			return closing
		end,

		terminate = function()
			closing = true
		end,
	}
end

function M.attach(bufnr)
	vim.lsp.start({
		name = "hades_r",
		cmd = server,
		offset_encoding = "utf-8",
		root_dir = vim.fs.root(bufnr, { ".lintr", ".git" }) or vim.fn.getcwd(),
	}, {
		bufnr = bufnr,
	})
end

return M
