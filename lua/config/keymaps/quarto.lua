local keys = require("config.utils.keymaps")

local M = {}

local function cmd(command)
	return "<cmd>" .. command .. "<CR>"
end

local function slides(fn)
	return function()
		require("config.utils.slides")[fn]()
	end
end

-- Keymaps de quarto / R markdown con el cursor fuera de un chunk
local context = {
	groups = {
		["<localleader>q"] = "[q]uarto",
	},

	maps = {
		-- Documento
		{ "n", "<localleader>qr", cmd("QuartoRender"), "[q]uarto [r]ender" },
		{ "n", "<localleader>qp", cmd("QuartoPreview"), "[q]uarto [p]review" },
		{ "n", "<localleader>qs", cmd("QuartoClosePreview"), "[q]uarto [s]top preview" },

		-- Presentaciones (reveal.js, plantilla en <config>/scripts/templates/slides)
		{ "n", "<localleader>qn", slides("new"), "[n]ew presentation" },
		{ "n", "<localleader>qh", slides("html"), "slides to [h]tml" },
		{ "n", "<localleader>qP", slides("pdf"), "slides to [P]DF (decktape)" },
	},
}

-- Dentro de un chunk, el menú del lenguaje (config.keymaps.chunk): el código
-- R va a R.nvim, la misma sesión que en los archivos .R
local function resolve(buf)
	local chunk = require("config.utils.chunks").at_cursor(buf)

	if chunk then
		return chunk.language, require("config.keymaps.chunk").context(chunk.language)
	end

	return "quarto", context
end

function M.setup(buf)
	-- Fijos en todo el buffer
	keys.buffer(buf, "n", "<S-Enter>", function()
		require("config.utils.markdown_runner").run_cell()
	end, "smart run [c]ell")

	-- ,sf: ejecuta todos los chunks de R del documento (R.nvim)
	keys.buffer_group(buf, "n", "<localleader>s", "[s]end")

	keys.buffer(buf, "n", "<localleader>sf", function()
		require("config.utils.markdown_runner").run_all("r")
	end, "send all R chunks of the [f]ile")

	-- Insertar <-, |> y chunks de R en modo inserción (<M-->, <M-m>, <M-r>)
	require("config.keymaps.r_editing").setup(buf, { chunks = true })

	-- Export a pdf/html con la plantilla de scripts/templates/hades
	require("config.keymaps.export").setup(buf)

	-- Contextuales: quarto fuera de los chunks, el lenguaje dentro
	require("config.utils.keymap_context").attach(buf, resolve, {
		"<localleader>q",
		"<localleader>r",
		"<localleader>v",
	})
end

return M
