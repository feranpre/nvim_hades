local M = {}

local LANGUAGE_MAP = {
	r = "r",
	python = "python",
	py = "python",
}

function M.normalize_language(language)
	language = vim.trim(language):lower()

	return LANGUAGE_MAP[language]
end

function M.repl(language)
	local ft = M.normalize_language(language)

	if not ft then
		return nil
	end

	local iron = require("iron.core")

	return iron.repl_for(ft), ft
end

function M.send(language, code)
	local repl, ft = M.repl(language)

	if not repl then
		vim.notify("Unsupported code language: " .. language, vim.log.levels.WARN)

		return false
	end

	require("iron.core").send(ft, code)

	return true
end

return M
