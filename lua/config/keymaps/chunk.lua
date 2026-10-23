-- Keymaps dentro de un bloque de código de markdown (R, python, bash).
-- Los usa config.keymaps.markdown como contexto cuando el cursor está en un
-- bloque: al pulsar <localleader> sale el menú del lenguaje, no el de markdown.
local M = {}

local NAMES = {
	r = "R",
	python = "python",
	bash = "bash",
}

local function run(fn, ...)
	local args = { ... }

	return function()
		require("config.utils.markdown_runner")[fn](unpack(args))
	end
end

local function console(fn, language)
	return function()
		require("config.utils.code_runner")[fn](language)
	end
end

function M.context(language)
	local name = NAMES[language]

	local maps = {
		-- Consola
		{ "n", "<localleader>rs", console("start", language), "[s]tart " .. name .. " console" },
		{ "n", "<localleader>rq", console("stop", language), "[q]uit " .. name .. " console" },
		{ "n", "<localleader>rc", console("clear", language), "[c]lear " .. name .. " console" },

		-- Ejecución
		{ "n", "<localleader>rr", run("run_cell"), "[r]un chunk" },
		{ "n", "<localleader>rl", run("run_line", language), "run [l]ine" },
		{ "v", "<localleader>rl", run("run_selection", language), "run selected [l]ines" },
		{ "n", "<localleader>ra", run("run_above", language), "run " .. name .. " chunks [a]bove" },
		{ "n", "<localleader>rA", run("run_all", language), "run [A]ll " .. name .. " chunks" },
		{ "n", "<C-CR>", run("run_cell_and_move"), "run chunk + move down" },

		-- Tapan los de mkdnflow (crear enlaces / items de lista) dentro del código
		{ "n", "<CR>", "<CR>", "next line" },
		{ "v", "<CR>", "<CR>", "next line" },
		{ "n", "o", "o", "open line below" },
		{ "n", "O", "O", "open line above" },
	}

	if language == "r" then
		vim.list_extend(maps, {
			{ "n", "<localleader>p", "<Plug>RObjectPr", "[p]rint object" },
			{ "n", "<localleader>h", "<Plug>RHelp", "[h]elp" },
			{ "n", "<localleader>vd", "<Plug>RViewDFa", "[v]iew [d]ata.frame" },
			{ "n", "<localleader>o", "<Plug>ROBToggle", "[o]bject inspector" },
		})
	end

	return {
		groups = {
			["<localleader>r"] = "[r]un " .. name,
			["<localleader>v"] = "[v]iew",
		},
		maps = maps,
	}
end

return M
