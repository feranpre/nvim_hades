-- config/utils/export.lua
--
-- Exporta el buffer actual (.md, .qmd, .Rmd) a PDF o HTML usando
-- scripts/md_to_pdf.py y las plantillas de scripts/pandoc_templates.
local M = {}

M.script = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts", "md_to_pdf.py")

M.formats = { "pdf", "html" }

local SUPPORTED_FT = {
	markdown = true,
	quarto = true,
	rmd = true,
}

-- Exportaciones en curso, para no lanzar dos veces la misma
local running = {}

local function tail(text, n)
	local lines = vim.split(vim.trim(text or ""), "\n")
	return table.concat(vim.list_slice(lines, math.max(1, #lines - n + 1)), "\n")
end

---@param format "pdf"|"html"
---@param opts? { open?: boolean, buf?: integer }
function M.export(format, opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(buf)

	if not vim.tbl_contains(M.formats, format) then
		vim.notify("Formato no soportado: " .. tostring(format), vim.log.levels.ERROR)
		return
	end

	if file == "" then
		vim.notify("El buffer no tiene un archivo asociado", vim.log.levels.WARN)
		return
	end

	if not SUPPORTED_FT[vim.bo[buf].filetype] then
		vim.notify("Solo se pueden exportar documentos markdown, quarto o R markdown", vim.log.levels.WARN)
		return
	end

	local python = vim.fn.exepath("python3")

	if python == "" then
		vim.notify("No se encuentra python3 en el PATH", vim.log.levels.ERROR)
		return
	end

	if vim.fn.filereadable(M.script) ~= 1 then
		vim.notify("No se encuentra el script de exportación: " .. M.script, vim.log.levels.ERROR)
		return
	end

	local key = file .. ":" .. format

	if running[key] then
		vim.notify("Ya se está exportando " .. vim.fs.basename(file) .. " a " .. format, vim.log.levels.WARN)
		return
	end

	if vim.bo[buf].modified then
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent write")
		end)
	end

	running[key] = true

	local name = vim.fs.basename(file)

	vim.notify("Exportando " .. name .. " a " .. format .. "...", vim.log.levels.INFO)

	vim.system({ python, M.script, file, "--to", format }, {
		cwd = vim.fs.dirname(file),
		text = true,
	}, function(result)
		vim.schedule(function()
			running[key] = nil

			if result.code ~= 0 then
				vim.notify(
					"Error al exportar " .. name .. ":\n" .. tail(result.stderr, 15),
					vim.log.levels.ERROR
				)
				return
			end

			-- El script imprime la ruta del archivo generado en stdout
			local stdout = vim.trim(result.stdout or "")
			local output = stdout ~= "" and tail(stdout, 1) or nil

			vim.notify("Exportado: " .. (output or name), vim.log.levels.INFO)

			if opts.open and output then
				vim.ui.open(output)
			end
		end)
	end)
end

-- :Export [pdf|html]   exporta el buffer actual (pdf por defecto)
-- :Export! [pdf|html]  exporta y abre el resultado
function M.create_command()
	vim.api.nvim_create_user_command("Export", function(cmd)
		M.export(cmd.args ~= "" and cmd.args or "pdf", { open = cmd.bang })
	end, {
		nargs = "?",
		bang = true,
		desc = "Exportar el documento a pdf/html (! para abrirlo)",
		complete = function()
			return M.formats
		end,
	})
end

return M
