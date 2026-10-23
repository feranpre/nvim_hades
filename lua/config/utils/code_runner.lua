-- Envío de código a la consola de cada lenguaje
--   r      -> R.nvim (misma sesión que en los archivos .R)
--   python -> iron.nvim
--   bash   -> iron.nvim (filetype "sh")
local M = {}

local LANGUAGE_MAP = {
	r = "r",
	python = "python",
	py = "python",
	bash = "bash",
	sh = "bash",
}

local IRON_FT = {
	python = "python",
	bash = "sh",
}

function M.normalize_language(language)
	language = vim.trim(language):lower()

	return LANGUAGE_MAP[language]
end

local backends = {}

backends.r = {
	start = function()
		require("r.run").start_R("R")
	end,

	stop = function()
		require("r.run").quit_R("nosave")
	end,

	clear = function()
		require("r.run").clear_console()
	end,

	send = function(code)
		require("r.send").cmd(code)
	end,
}

local function iron_backend(ft)
	return {
		start = function()
			require("iron.core").repl_for(ft)
		end,

		stop = function()
			require("iron.core").close_repl(ft)
		end,

		clear = function()
			require("iron.core").send(ft, string.char(12))
		end,

		send = function(code)
			require("iron.core").send(ft, code)
		end,
	}
end

for language, ft in pairs(IRON_FT) do
	backends[language] = iron_backend(ft)
end

local function backend(language)
	local lang = M.normalize_language(language)
	local b = lang and backends[lang]

	if not b then
		vim.notify("Unsupported code language: " .. language, vim.log.levels.WARN)
	end

	return b
end

function M.start(language)
	local b = backend(language)

	if b then
		b.start()
	end
end

function M.stop(language)
	local b = backend(language)

	if b then
		b.stop()
	end
end

function M.clear(language)
	local b = backend(language)

	if b then
		b.clear()
	end
end

function M.send(language, code)
	local b = backend(language)

	if not b then
		return false
	end

	b.send(code)

	return true
end

return M
