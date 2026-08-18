local M = {}

function M.foldexpr()
	local line = vim.fn.getline(vim.v.lnum)

	local heading = line:match("^%s*(#+)%s+")

	if heading then
		return ">" .. #heading
	end

	return "="
end

function M.foldtext()
	local start = vim.v.foldstart
	local finish = vim.v.foldend

	local line = vim.fn.getline(start)

	-- Número de líneas ocultas, sin contar el encabezado.
	local lines = finish - start

	-- Mantener exactamente el encabezado.
	local text = line .. " [" .. lines .. " lines] "

	-- Añadir puntos hasta llenar razonablemente el espacio.
	local width = vim.api.nvim_win_get_width(0)
	local current_width = vim.fn.strdisplaywidth(text)

	if current_width < width then
		text = text .. string.rep(".", width - current_width - 1)
	end

	return text
end

function M.setup()
	vim.opt_local.foldmethod = "expr"

	vim.opt_local.foldexpr = "v:lua.require('config.utils.markdown_folding').foldexpr()"

	vim.opt_local.foldtext = "v:lua.require('config.utils.markdown_folding').foldtext()"

	vim.opt_local.foldenable = true
	vim.opt_local.foldlevel = 99
	vim.opt_local.foldminlines = 0
end

return M
