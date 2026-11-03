-- config/utils/export.lua
--
-- Exporta el buffer actual (.md, .qmd, .Rmd, .R) a PDF o HTML usando
-- scripts/md_to_pdf.py y las plantillas de scripts/templates/hades.
-- Mientras tanto muestra una ventana de progreso (config.utils.export_progress).
local M = {}

M.script = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts", "md_to_pdf.py")

M.formats = { "pdf", "html" }

local SUPPORTED_FT = {
	markdown = true,
	quarto = true,
	rmd = true,
	-- scripts .R con comentarios #' (knitr::spin), renderizados con quarto
	r = true,
}

-- Exportaciones en curso (clave archivo:formato -> { proc, progress }),
-- para no lanzar dos veces la misma y poder cancelarlas
local running = {}

local function tail(text, n)
	local lines = vim.split(vim.trim(text or ""), "\n")
	return table.concat(vim.list_slice(lines, math.max(1, #lines - n + 1)), "\n")
end

---@param format "pdf"|"html"
---@param opts? { open?: boolean, buf?: integer, quiet?: boolean }
---  quiet: sin aviso al terminar bien ni si ya se está exportando (al guardar)
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
		vim.notify("Solo se pueden exportar documentos markdown, quarto, R markdown o scripts R", vim.log.levels.WARN)
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
		if opts.quiet then
			-- al guardar durante una exportación: se repite al terminar
			running[key].again = true
		else
			vim.notify("Ya se está exportando " .. vim.fs.basename(file) .. " a " .. format, vim.log.levels.WARN)
		end
		return
	end

	if vim.bo[buf].modified then
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent write")
		end)
	end

	local name = vim.fs.basename(file)
	local progress = require("config.utils.export_progress").new(name, format, key)

	-- stderr llega a trozos: se junta en líneas completas
	local pending = ""

	local function on_stderr(_, data)
		if not data then
			return
		end

		pending = pending .. data
		local lines = vim.split(pending, "\n", { plain = true })
		pending = table.remove(lines)

		vim.schedule(function()
			for _, line in ipairs(lines) do
				progress:feed(line)
			end
		end)
	end

	local function on_exit(result)
		vim.schedule(function()
			local again = running[key] and running[key].again
			running[key] = nil

			if pending ~= "" then
				progress:feed(pending)
			end

			local summary = progress:finish(result.code == 0 and not progress.cancelled)

			-- se guardó otra vez mientras exportaba: se exporta la versión nueva
			if again and not progress.cancelled and vim.api.nvim_buf_is_valid(buf) then
				vim.schedule(function()
					M.export(format, { buf = buf, quiet = true })
				end)
			end

			if progress.cancelled then
				vim.notify("Exportación de " .. name .. " cancelada", vim.log.levels.WARN)
				return
			end

			if result.code ~= 0 then
				local log = vim.list_slice(progress.log, math.max(1, #progress.log - 14))
				vim.notify("Error al exportar " .. name .. ":\n" .. table.concat(log, "\n"), vim.log.levels.ERROR)
				return
			end

			-- El script imprime la ruta del archivo generado en stdout
			local stdout = vim.trim(result.stdout or "")
			local output = stdout ~= "" and tail(stdout, 1) or nil

			if opts.quiet then
				return
			end

			vim.notify(
				"Exportado " .. table.concat(summary, "\n") .. "\n" .. (output or name),
				vim.log.levels.INFO
			)

			if opts.open and output then
				vim.ui.open(output)
			end
		end)
	end

	local ok, proc = pcall(vim.system, { python, M.script, file, "--to", format }, {
		cwd = vim.fs.dirname(file),
		text = true,
		stderr = on_stderr,
		-- grupo de procesos propio: al cancelar se puede matar también a quarto y R
		detach = true,
	}, on_exit)

	if not ok then
		progress:finish()
		vim.notify("No se pudo lanzar la exportación: " .. tostring(proc), vim.log.levels.ERROR)
		return
	end

	running[key] = { proc = proc, progress = progress }
end

-- Exportar al guardar: ,ew lo activa (pregunta el formato) o lo quita.
-- Los visores de PDF que recargan solos (zathura, evince, okular, sioyek)
-- muestran cada versión; en HTML basta con recargar el navegador.
function M.toggle_watch(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local name = vim.fs.basename(vim.api.nvim_buf_get_name(buf))
	local group = vim.api.nvim_create_augroup("HadesExportWatch" .. buf, { clear = true })

	if vim.b[buf].hades_export_watch then
		vim.b[buf].hades_export_watch = nil
		vim.notify("Ya no se exporta " .. name .. " al guardar", vim.log.levels.INFO)
		return
	end

	vim.ui.select(M.formats, { prompt = "Exportar al guardar a" }, function(format)
		if not format then
			return
		end

		vim.b[buf].hades_export_watch = format

		vim.api.nvim_create_autocmd("BufWritePost", {
			group = group,
			buffer = buf,
			callback = function()
				if vim.b[buf].hades_export_watch then
					M.export(vim.b[buf].hades_export_watch, { buf = buf, quiet = true })
				end
			end,
		})

		vim.notify("Se exportará " .. name .. " a " .. format .. " cada vez que guardes (,ew para quitarlo)")

		-- primera exportación, y se abre para tenerla a la vista
		M.export(format, { buf = buf, open = true })
	end)
end

-- Cancela las exportaciones en curso (todas, o solo las del archivo indicado)
function M.cancel(file)
	local n = 0

	for key, job in pairs(running) do
		if not file or vim.startswith(key, file .. ":") then
			job.progress.cancelled = true
			-- el proceso es líder de su grupo (detach): -pid llega a quarto y R
			pcall(vim.uv.kill, -job.proc.pid, "sigterm")
			n = n + 1
		end
	end

	if n == 0 then
		vim.notify("No hay ninguna exportación en marcha", vim.log.levels.INFO)
	end
end

-- :Export [pdf|html]   exporta el buffer actual (pdf por defecto)
-- :Export! [pdf|html]  exporta y abre el resultado
-- :ExportCancel        cancela las exportaciones en curso
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

	vim.api.nvim_create_user_command("ExportCancel", function()
		M.cancel()
	end, { desc = "Cancelar las exportaciones en curso" })
end

return M
