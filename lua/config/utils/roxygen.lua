-- Continuar los comentarios #' (roxygen / knitr::spin) al pulsar Intro u o/O.
--
-- El ftplugin de R ya declara #' como comentario ('comments'), pero para que
-- se continúe hace falta formatoptions+=ro, que también continuaría los # normales.
-- Por eso se activa solo mientras el cursor está en una línea que empieza
-- por #'.
local M = {}

local function update(buf)
	local line = vim.api.nvim_get_current_line()
	local fo = vim.bo[buf].formatoptions

	fo = fo:gsub("[ro]", "")

	if line:match("^%s*#'") then
		fo = fo .. "ro"
	end

	vim.bo[buf].formatoptions = fo
end

function M.setup(buf)
	local group = vim.api.nvim_create_augroup("RoxygenContinue" .. buf, { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorMovedI", "InsertEnter" }, {
		group = group,
		buffer = buf,
		callback = function()
			update(buf)
		end,
	})

	update(buf)
end

return M
