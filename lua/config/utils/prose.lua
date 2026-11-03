-- config/utils/prose.lua
--
-- Ajustes para escribir texto (markdown, quarto, R markdown):
--   - las líneas largas se ven partidas por palabras (sin cambiar el archivo)
--     y j / k se mueven por líneas de pantalla;
--   - ortografía en castellano e inglés (<leader>s o :Ortografia; z= da
--     sugerencias, ]s / [s saltan entre errores, zg añade la palabra);
--   - formato con la selección: ,mb negrita, ,mi cursiva, ,mc código,
--     ,mk enlace.
local M = {}

M.spelllang = "es,en"

local SPELL_URL = "https://ftp.nluug.nl/pub/vim/runtime/spell/"
local SPELL_DIR = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "spell")

-- lazy.nvim reescribe el runtimepath: la carpeta de los diccionarios
-- descargados se añade a mano para que Neovim los encuentre
local SITE = vim.fs.dirname(SPELL_DIR)

if not vim.tbl_contains(vim.opt.runtimepath:get(), SITE) then
	vim.opt.runtimepath:append(SITE)
end

local function has_dictionary(lang)
	return #vim.api.nvim_get_runtime_file("spell/" .. lang .. ".utf-8.spl", false) > 0
end

-- Descarga el diccionario (español) si falta. Neovim lo ofrece solo, pero
-- su descarga usa netrw, que está desactivado por oil.
local function download(lang, done)
	if vim.fn.executable("curl") ~= 1 then
		vim.notify("Hace falta curl para descargar el diccionario", vim.log.levels.ERROR)
		return
	end

	vim.fn.mkdir(SPELL_DIR, "p")

	local files = { lang .. ".utf-8.spl", lang .. ".utf-8.sug" }
	local pending = #files
	local failed = false

	vim.notify("Descargando el diccionario '" .. lang .. "'...", vim.log.levels.INFO)

	for _, name in ipairs(files) do
		local target = vim.fs.joinpath(SPELL_DIR, name)

		vim.system({ "curl", "-fsSL", "-o", target, SPELL_URL .. name }, {}, function(res)
			vim.schedule(function()
				-- el .sug (sugerencias) es opcional
				if res.code ~= 0 and name:match("%.spl$") then
					failed = true
					os.remove(target)
				end

				pending = pending - 1

				if pending == 0 then
					if failed then
						vim.notify("No se pudo descargar el diccionario de " .. SPELL_URL, vim.log.levels.ERROR)
					else
						vim.notify("Diccionario '" .. lang .. "' instalado en " .. SPELL_DIR, vim.log.levels.INFO)
						done()
					end
				end
			end)
		end)
	end
end

-- Activa / desactiva la ortografía en la ventana actual
function M.toggle_spell()
	if vim.wo.spell then
		vim.wo.spell = false
		vim.notify("Ortografía desactivada", vim.log.levels.INFO)
		return
	end

	local function enable()
		vim.bo.spelllang = M.spelllang
		vim.wo.spell = true
		vim.notify("Ortografía (" .. M.spelllang .. "): z= sugerencias, ]s / [s errores, zg añadir palabra")
	end

	if has_dictionary("es") then
		enable()
	else
		download("es", enable)
	end
end

-- Rodea la selección (visual) con before / after
local function surround(before, after)
	return function()
		local s = vim.fn.getpos("v")
		local e = vim.fn.getpos(".")

		if s[2] > e[2] or (s[2] == e[2] and s[3] > e[3]) then
			s, e = e, s
		end

		local mode = vim.fn.mode()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)

		if mode == "V" then
			s[3] = 1
			e[3] = #vim.fn.getline(e[2])
		end

		-- columnas en bytes: el final incluye el carácter completo (UTF-8)
		local last = vim.fn.getline(e[2])
		local end_col = e[3]

		while end_col < #last and bit.band(last:byte(end_col + 1), 0xC0) == 0x80 do
			end_col = end_col + 1
		end

		vim.api.nvim_buf_set_text(0, e[2] - 1, end_col, e[2] - 1, end_col, { after })
		vim.api.nvim_buf_set_text(0, s[2] - 1, s[3] - 1, s[2] - 1, s[3] - 1, { before })
	end
end

local function link()
	vim.ui.input({ prompt = "URL: " }, function(url)
		if url and url ~= "" then
			surround("[", "](" .. url .. ")")()
		end
	end)
end

function M.setup(buf)
	local keys = require("config.utils.keymaps")

	-- Opciones de ventana para este buffer
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
	vim.opt_local.breakindent = true
	vim.opt_local.breakindentopt = "list:-1"
	vim.opt_local.spelllang = M.spelllang

	-- Ortografía activada si el diccionario ya está instalado
	if has_dictionary("es") then
		vim.opt_local.spell = true
	end

	-- j / k por líneas de pantalla (con cuenta, por líneas reales: 5j)
	keys.buffer(buf, { "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", nil, { expr = true })
	keys.buffer(buf, { "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", nil, { expr = true })

	-- Formato de la selección
	keys.buffer_group(buf, "x", "<localleader>m", "[m]arkdown")
	keys.buffer(buf, "x", "<localleader>mb", surround("**", "**"), "[b]old")
	keys.buffer(buf, "x", "<localleader>mi", surround("*", "*"), "[i]talic")
	keys.buffer(buf, "x", "<localleader>mc", surround("`", "`"), "inline [c]ode")
	keys.buffer(buf, "x", "<localleader>mk", link, "lin[k]")

	-- Índice del documento (gO) y saltos entre secciones (]] [[)
	require("config.utils.outline").setup(buf)
end

-- Comandos globales
function M.create_commands()
	vim.api.nvim_create_user_command("Ortografia", M.toggle_spell, {
		desc = "Activar / desactivar la ortografía (descarga el diccionario si falta)",
	})

	require("config.utils.keymaps").map("n", "<leader>s", M.toggle_spell, "ortografía (on/off)")
end

return M
