-- Keymaps de buffer que cambian según dónde esté el cursor.
--
-- Un "contexto" es una tabla:
--   {
--     groups = { ["<localleader>r"] = "[r]un R" },
--     maps = { { mode, lhs, rhs, desc }, ... },
--   }
-- Al moverse el cursor se resuelve el contexto actual y, si ha cambiado, se
-- quitan los keymaps del anterior y se ponen los del nuevo. which-key lee los
-- keymaps del buffer al pulsar <localleader>, así que el menú es contextual.
local keys = require("config.utils.keymaps")

local M = {}

-- buf -> {
--   name = contexto actual,
--   maps = keymaps puestos,
--   saved = keymaps de buffer que tapaban (p. ej. de mkdnflow), para restaurarlos,
--   labels = grupos,
-- }
local state = {}

local function clear(buf)
	local s = state[buf]

	for _, map in ipairs(s.maps) do
		pcall(vim.keymap.del, map[1], map[2], { buffer = buf })
	end

	for _, saved in ipairs(s.saved) do
		vim.api.nvim_buf_call(buf, function()
			vim.fn.mapset(saved.mode, false, saved.map)
		end)
	end

	s.maps = {}
	s.saved = {}
	s.labels = {}
end

local function apply(buf, name, context)
	local s = state[buf]

	clear(buf)

	for _, map in ipairs(context.maps or {}) do
		local previous = vim.api.nvim_buf_call(buf, function()
			return vim.fn.maparg(map[2], map[1], false, true)
		end)

		if previous.buffer == 1 then
			table.insert(s.saved, { mode = map[1], map = previous })
		end

		keys.buffer(buf, map[1], map[2], map[3], map[4])
		table.insert(s.maps, map)
	end

	s.labels = context.groups or {}
	s.name = name

	-- which-key cachea el árbol de keymaps del buffer: forzar que lo rehaga
	local ok, wk_buf = pcall(require, "which-key.buf")

	if ok then
		wk_buf.clear({ buf = buf })
	end
end

-- Etiqueta de un grupo en el contexto actual. Los grupos sin keymaps no los
-- muestra which-key, así que basta con devolver algo.
local function label(buf, lhs)
	return function()
		local s = state[buf]

		return s and s.labels[lhs] or lhs
	end
end

-- resolve(buf) -> nombre del contexto, tabla del contexto
-- group_lhs: todos los prefijos de grupo que puede usar algún contexto
function M.attach(buf, resolve, group_lhs)
	if state[buf] then
		return
	end

	state[buf] = { maps = {}, saved = {}, labels = {} }

	local ok, wk = pcall(require, "which-key")

	if ok then
		for _, lhs in ipairs(group_lhs) do
			wk.add({ lhs, group = label(buf, lhs), buffer = buf, mode = "n" })
		end
	end

	local function update()
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local name, context = resolve(buf)

		if name ~= state[buf].name then
			apply(buf, name, context)
		end
	end

	local group = vim.api.nvim_create_augroup("KeymapContext" .. buf, { clear = true })

	vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter", "InsertLeave", "TextChanged" }, {
		group = group,
		buffer = buf,
		callback = update,
	})

	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		buffer = buf,
		callback = function()
			state[buf] = nil
			vim.api.nvim_del_augroup_by_id(group)
		end,
	})

	update()
end

-- Nombre del contexto actual del buffer (útil para lualine o depurar)
function M.current(buf)
	local s = state[buf or vim.api.nvim_get_current_buf()]

	return s and s.name
end

return M
