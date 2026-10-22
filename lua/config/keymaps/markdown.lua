local keys = require("config.utils.keymaps")

local M = {}

local function pandoc(kind)
	return function()
		require("config.utils.pandoc").convert(kind)
	end
end

local function cmd(command)
	return "<cmd>" .. command .. "<CR>"
end

local function new_table()
	vim.ui.input({ prompt = "Columnas x filas: ", default = "3 2" }, function(input)
		if input and input ~= "" then
			vim.cmd("MkdnTable " .. input:gsub("x", " "))
		end
	end)
end

-- Keymaps de markdown (cursor fuera de un bloque de código)
local context = {
	groups = {
		["<localleader>k"] = "[k]nit / export",
		["<localleader>m"] = "[m]arkdown",
		["<localleader>t"] = "[t]able",
	},

	maps = {
		-- Export (pandoc, scripts en <config>/scripts)
		{ "n", "<localleader>kp", pandoc("pdf"), "export to [p]df" },
		{ "n", "<localleader>kh", pandoc("html"), "export to [h]tml" },
		{ "n", "<localleader>ku", pandoc("utamed"), "export to [u]tamed pdf" },

		-- Markdown (mkdnflow / render-markdown)
		{ "n", "<localleader>mr", cmd("RenderMarkdown buf_toggle"), "toggle [r]endering" },
		{ "n", "<localleader>mx", cmd("MkdnToggleToDo"), "toggle to-do [x]" },
		{ "v", "<localleader>mx", ":MkdnToggleToDo<CR>", "toggle to-do [x]" },
		{ "n", "<localleader>mn", cmd("MkdnUpdateNumbering"), "update list [n]umbering" },
		{ "n", "<localleader>ml", cmd("MkdnCreateLinkFromClipboard"), "create [l]ink from clipboard" },
		{ "n", "<localleader>mf", cmd("MkdnCreateFootnote"), "new [f]ootnote" },

		-- Tablas
		{ "n", "<localleader>tn", new_table, "[n]ew table" },
		{ "n", "<localleader>tf", cmd("MkdnTableFormat"), "[f]ormat table" },
		{ "n", "<localleader>tr", cmd("MkdnTableNewRowBelow"), "new [r]ow below" },
		{ "n", "<localleader>tR", cmd("MkdnTableNewRowAbove"), "new [R]ow above" },
		{ "n", "<localleader>tc", cmd("MkdnTableNewColAfter"), "new [c]olumn after" },
		{ "n", "<localleader>tC", cmd("MkdnTableNewColBefore"), "new [C]olumn before" },
		{ "n", "<localleader>td", cmd("MkdnTableDeleteRow"), "[d]elete row" },
		{ "n", "<localleader>tD", cmd("MkdnTableDeleteCol"), "[D]elete column" },
	},
}

local function resolve(buf)
	local chunk = require("config.utils.chunks").at_cursor(buf)

	if chunk then
		return chunk.language, require("config.keymaps.chunk").context(chunk.language)
	end

	return "markdown", context
end

function M.setup(buf)
	-- Fijos en todo el buffer
	keys.buffer(buf, "n", "<S-Enter>", function()
		require("config.utils.markdown_runner").run_cell()
	end, "smart run [c]ell")

	-- Contextuales: markdown fuera de los bloques, el lenguaje dentro
	require("config.utils.keymap_context").attach(buf, resolve, {
		"<localleader>k",
		"<localleader>m",
		"<localleader>t",
		"<localleader>r",
		"<localleader>v",
	})
end

return M
