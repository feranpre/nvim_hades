-- config/utils/outline.lua
--
-- Índice del documento: lista de títulos y saltos entre secciones.
--
--   markdown / quarto / rmd   títulos "# ...", sin contar los que hay dentro
--                             de bloques de código ni de la cabecera YAML
--   R                         títulos de texto knitr::spin ("#' ## ...") y
--                             secciones al estilo RStudio ("# Carga ----")
--
-- gO abre el índice (telescope, empieza en la sección del cursor);
-- ]] / [[ saltan a la sección siguiente / anterior (admiten cuenta: 3]]).
local M = {}

---@class OutlineItem
---@field lnum integer
---@field level integer
---@field text string

-- Quita {#sec-id .clase} y almohadillas de cierre
local function clean(text)
	text = text:gsub("%s*{[^}]*}%s*$", "")
	text = text:gsub("%s+#+%s*$", "")
	return vim.trim(text)
end

local function yaml_end(lines, prefix)
	prefix = prefix or ""
	local open = "^" .. vim.pesc(prefix) .. "%-%-%-%s*$"

	if not (lines[1] and lines[1]:match(open)) then
		return 0
	end

	for i = 2, #lines do
		if lines[i]:match(open) or lines[i]:match("^" .. vim.pesc(prefix) .. "%.%.%.%s*$") then
			return i
		end
	end

	return 0
end

---@return OutlineItem[]
local function markdown(lines)
	local items = {}
	local fence -- carácter y longitud de la valla del bloque abierto

	for i = yaml_end(lines) + 1, #lines do
		local line = lines[i]
		local marks = line:match("^%s*(```+)") or line:match("^%s*(~~~+)")

		if fence then
			-- se cierra con una valla igual (o más larga) y nada más
			if marks and marks:sub(1, 1) == fence.char and #marks >= fence.len and line:match("^%s*[`~]+%s*$") then
				fence = nil
			end
		elseif marks then
			fence = { char = marks:sub(1, 1), len = #marks }
		else
			local hashes, text = line:match("^(#+)%s+(.+)$")

			if hashes and #hashes <= 6 then
				table.insert(items, { lnum = i, level = #hashes, text = clean(text) })
			end
		end
	end

	return items
end

---@return OutlineItem[]
local function r(lines)
	local items = {}

	for i = yaml_end(lines, "#' ") + 1, #lines do
		local line = lines[i]

		-- texto de knitr::spin: #' ## Título
		local hashes, text = line:match("^#'%s*(#+)%s+(.+)$")

		-- sección de RStudio: # Título ----  (también ==== o ####)
		if not hashes then
			hashes, text = line:match("^(#+)%s*([^#'].-)%s*[-=#][-=#][-=#][-=#]+%s*$")
		end

		if hashes and #hashes <= 6 and text and vim.trim(text) ~= "" then
			table.insert(items, { lnum = i, level = #hashes, text = clean(text) })
		end
	end

	return items
end

---@param buf? integer
---@return OutlineItem[]
function M.headings(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	if vim.bo[buf].filetype == "r" then
		return r(lines)
	end

	return markdown(lines)
end

-- Salta a la sección siguiente (dir = 1) o anterior (dir = -1)
function M.jump(dir)
	local items = M.headings()
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local target

	for _ = 1, math.max(1, vim.v.count) do
		local found

		if dir > 0 then
			for _, item in ipairs(items) do
				if item.lnum > cur then
					found = item.lnum
					break
				end
			end
		else
			for i = #items, 1, -1 do
				if items[i].lnum < cur then
					found = items[i].lnum
					break
				end
			end
		end

		if not found then
			break
		end

		target, cur = found, found
	end

	if target then
		vim.cmd("normal! m'")
		vim.api.nvim_win_set_cursor(0, { target, 0 })
	end
end

-- Líneas de la sección del cursor: desde su título hasta antes del
-- siguiente del mismo nivel o superior. Sin título encima: desde el principio.
---@return integer first, integer last
function M.section_range(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local items = M.headings(buf)
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local first, level, last = 1, 0, vim.api.nvim_buf_line_count(buf)

	for _, item in ipairs(items) do
		if item.lnum <= cur then
			first, level = item.lnum, item.level
		elseif level == 0 or item.level <= level then
			last = item.lnum - 1
			break
		end
	end

	return first, last
end

-- Índice en telescope (o vim.ui.select si no está)
function M.pick()
	local buf = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()
	local items = M.headings(buf)

	if #items == 0 then
		vim.notify("El documento no tiene títulos", vim.log.levels.INFO)
		return
	end

	-- La sección en la que está el cursor
	local cur = vim.api.nvim_win_get_cursor(win)[1]
	local current = 1

	for i, item in ipairs(items) do
		if item.lnum <= cur then
			current = i
		end
	end

	local min_level = math.huge

	for _, item in ipairs(items) do
		min_level = math.min(min_level, item.level)
	end

	local function label(item)
		return string.rep("  ", item.level - min_level) .. item.text
	end

	local function go(item)
		vim.api.nvim_set_current_win(win)
		vim.cmd("normal! m'")
		vim.api.nvim_win_set_cursor(win, { item.lnum, 0 })
		vim.cmd("normal! zvzt")
	end

	local ok = pcall(require, "telescope")

	if not ok then
		vim.ui.select(items, { prompt = "Índice", format_item = label }, function(item)
			if item then
				go(item)
			end
		end)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local state = require("telescope.actions.state")
	local file = vim.api.nvim_buf_get_name(buf)

	pickers
		.new({}, {
			prompt_title = "Índice",
			default_selection_index = current,
			finder = finders.new_table({
				results = items,
				entry_maker = function(item)
					return {
						value = item,
						display = label(item),
						ordinal = item.text,
						filename = file,
						bufnr = buf,
						lnum = item.lnum,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.qflist_previewer({}),
			attach_mappings = function(bufnr)
				actions.select_default:replace(function()
					local entry = state.get_selected_entry()
					actions.close(bufnr)

					if entry then
						go(entry.value)
					end
				end)

				return true
			end,
		})
		:find()
end

-- gO, ]] y [[ en el buffer
function M.setup(buf)
	local keys = require("config.utils.keymaps")

	keys.buffer(buf, "n", "gO", M.pick, "índice del documento (outline)")

	keys.buffer(buf, { "n", "x" }, "]]", function()
		M.jump(1)
	end, "siguiente sección")

	keys.buffer(buf, { "n", "x" }, "[[", function()
		M.jump(-1)
	end, "sección anterior")
end

return M
