-- Autocompletado de rutas relativas SIN "./" para blink.cmp
--
-- La fuente "path" de blink solo completa rutas que empiezan por "./",
-- "../", "~/" o "/": en "DATOS_BASE/ ve una letra antes de "/" y lo toma
-- por un trozo de URL. Esta fuente completa las rutas relativas escritas
-- dentro de una cadena ("DATOS_BASE/datos.xlsx", 'img/figura.png') o de un
-- enlace de markdown (](img/...)), en los tipos de archivo de FILETYPES.
--
-- Las rutas se buscan desde:
--   - .R: el directorio de trabajo de Neovim, que es el de R (R.nvim con
--     setwd = "nvim").
--   - .qmd, .Rmd, .md: la carpeta del documento (Quarto/knitr ejecutan ahí).
--
-- Sin "/" (p. ej. "DAT) solo propone lo que empieza por lo escrito, para no
-- abrir la lista de archivos en cada cadena.

local M = {}

local FILETYPES = { r = true, quarto = true, rmd = true, markdown = true }
local MAX_ENTRIES = 500

function M.new(opts)
	return setmetatable({ opts = opts or {} }, { __index = M })
end

function M:enabled()
	return FILETYPES[vim.bo.filetype] == true
end

function M:get_trigger_characters()
	return { "/", '"', "'" }
end

-- Texto de la ruta que se está escribiendo (o nil si el cursor no está en una
-- cadena o un enlace)
local function current_path(before)
	for _, q in ipairs({ '"', "'" }) do
		local text = before:match(q .. "([^" .. q .. "]*)$")
		if text then
			-- comillas sin escapar antes del cursor: impar = dentro de la cadena
			local n = select(2, before:gsub("\\" .. q, "")) -- quitar las escapadas
			local count = select(2, before:gsub(q, "")) - n
			if count % 2 == 1 then
				return text
			end
		end
	end

	return before:match("%]%(([^%s%)]*)$")
end

local function base_dir(ctx)
	if vim.bo[ctx.bufnr].filetype == "r" then
		return vim.fn.getcwd()
	end

	return vim.fn.expand(("#%d:p:h"):format(ctx.bufnr))
end

function M:get_completions(ctx, callback)
	local empty = { items = {}, is_incomplete_forward = true, is_incomplete_backward = true }
	local col = ctx.cursor[2]
	local before = ctx.line:sub(1, col)
	local text = current_path(before)

	-- las rutas con ./ ../ ~/ / ya las completa la fuente "path"; fuera URLs y
	-- variables de entorno
	if
		not text
		or text:match("^%.%.?/")
		or text:match("^[~/]")
		or text:match("^%a[%w+.-]*://")
		or text:find("$", 1, true)
	then
		return callback(empty)
	end

	local dir, name = text:match("^(.*/)([^/]*)$")
	if not dir then
		dir, name = "", text
		if name == "" then
			return callback(empty)
		end
	end

	local full = vim.fs.joinpath(base_dir(ctx), dir)
	local handle = vim.uv.fs_scandir(full)
	if not handle then
		return callback(empty)
	end

	local kinds = require("blink.cmp.types").CompletionItemKind
	local row = ctx.cursor[1] - 1
	local next_is_slash = ctx.line:sub(col + 1, col + 1) == "/"
	local show_hidden = name:sub(1, 1) == "."
	local lname = name:lower()
	local items = {}

	while #items < MAX_ENTRIES do
		local entry, type = vim.uv.fs_scandir_next(handle)
		if not entry then
			break
		end

		if type == "link" then
			local stat = vim.uv.fs_stat(vim.fs.joinpath(full, entry))
			type = stat and stat.type or type
		end

		local hidden = entry:sub(1, 1) == "."
		-- sin "/" solo lo que empieza por lo escrito
		local matches = dir ~= "" or entry:lower():sub(1, #lname) == lname

		if (show_hidden or not hidden) and matches then
			local is_dir = type == "directory"
			local label = is_dir and (entry .. "/") or entry

			table.insert(items, {
				label = label,
				filterText = entry,
				kind = is_dir and kinds.Folder or kinds.File,
				sortText = (is_dir and "1" or "2") .. entry:lower(),
				textEdit = {
					newText = label,
					range = {
						start = { line = row, character = col - #name },
						["end"] = { line = row, character = col + ((is_dir and next_is_slash) and 1 or 0) },
					},
				},
			})
		end
	end

	callback({
		items = items,
		-- sin "/" la lista depende de lo escrito: volver a pedirla al escribir
		is_incomplete_forward = dir == "",
		is_incomplete_backward = true,
	})
end

return M
