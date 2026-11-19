-- Surround: añadir, borrar y reemplazar delimitadores (mini.surround)
--
--   sa{char}          rodea la palabra bajo el cursor      palabra  -> (palabra)   [sa(]
--   sa{n}{char}       rodea la palabra n veces             palabra  -> [[palabra]] [sa2[]
--   sa{motion}{char}  rodea un movimiento/objeto de texto  saiW"  sae)  sa2j]
--   (visual) sa{char} rodea la selección
--   sd{char}          borra el delimitador                 (palabra) -> palabra   [sd(]
--   sr{old}{new}      reemplaza el delimitador             (palabra) -> [palabra] [sr([]
--   sf / sF           busca delimitador a la derecha / izquierda
--   sh                resalta el delimitador
--
--   Caracteres especiales: t = etiqueta HTML (pregunta el nombre),
--   f = llamada a función (pregunta el nombre), ? = pregunta izquierda/derecha.
--   Nota: mini.surround desactiva la `s` nativa (sustituir carácter); usa `cl`.
--   ( [ { < no añaden espacios interiores (igual que ) ] } >).

-- Teclas que, tras `sa`, se interpretan como inicio de movimiento/objeto de
-- texto en vez de como delimitador. Todo lo demás rodea la palabra.
local motion_keys = {
	i = true, a = true,
	w = true, W = true, e = true, E = true, b = true, B = true,
	h = true, j = true, k = true, l = true,
	["0"] = true, ["^"] = true, G = true, g = true,
	t = true, T = true, f = true, F = true,
	["%"] = true, ["/"] = true, n = true, N = true,
	[";"] = true, [","] = true, ["|"] = true,
	v = true, V = true, ["\22"] = true, -- <C-v>
}

local function surround_add()
	local count = vim.v.count > 0 and tostring(vim.v.count) or ""

	-- Leer un número opcional después de `sa` (sa2[)
	local ok, char = pcall(vim.fn.getcharstr)
	while ok and char:match("^%d$") and not (char == "0" and count == "") do
		count = count .. char
		ok, char = pcall(vim.fn.getcharstr)
	end

	if not ok or char == "\27" then -- <Esc> / interrupción
		return
	end

	local keys
	if motion_keys[char] then
		-- Operador normal de mini.surround: el resto (objeto y delimitador)
		-- lo sigue escribiendo el usuario
		keys = count .. "<Plug>(hades-surround-add)" .. char
	else
		keys = count .. "<Plug>(hades-surround-add)iw" .. char
	end

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "m", false)
end

return {
	{
		"nvim-mini/mini.surround",

		version = "*",

		event = "VeryLazy",

		opts = {
			custom_surroundings = {
				["("] = { output = { left = "(", right = ")" } },
				["["] = { output = { left = "[", right = "]" } },
				["{"] = { output = { left = "{", right = "}" } },
				["<"] = { output = { left = "<", right = ">" } },
			},

			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				suffix_last = "l",
				suffix_next = "n",
			},

			n_lines = 50,
		},

		config = function(_, opts)
			require("mini.surround").setup(opts)

			-- Guardar el operador original de mini.surround en un <Plug>
			-- y sustituir `sa` en modo normal por la versión "sobre la palabra"
			local original = vim.fn.maparg("sa", "n", false, true)
			if original and original.callback then
				vim.keymap.set("n", "<Plug>(hades-surround-add)", original.callback, {
					expr = true,
					silent = true,
				})

				vim.keymap.set("n", "sa", surround_add, {
					desc = "Surround add (palabra, n veces o movimiento)",
				})
			end
		end,
	},
}
