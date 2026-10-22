local M = {}

-- Todos los scripts de la configuración viven en <config>/scripts
M.scripts_dir = vim.fn.stdpath("config") .. "/scripts"

local SCRIPTS = {
	pdf = "md_to_pdf.py",
	html = "md_to_html.py",
	utamed = "utamed_pdf.py",
}

local function run_async(cmd, cwd, label)
	vim.notify(label .. "...", vim.log.levels.INFO)

	vim.fn.jobstart(cmd, {
		cwd = cwd,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stderr = function(_, data)
			if data and #data > 0 and data[1] ~= "" then
				vim.notify("Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
			end
		end,
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				vim.notify(label .. " OK", vim.log.levels.INFO)
			else
				vim.notify(label .. " ERROR", vim.log.levels.ERROR)
			end
		end,
	})
end

-- Convierte el archivo con pandoc usando uno de los scripts de <config>/scripts
-- kind: "pdf", "html" o "utamed"
function M.convert(kind, file_path)
	file_path = file_path or vim.api.nvim_buf_get_name(0)

	if file_path == "" then
		vim.notify("Error: buffer sin archivo.", vim.log.levels.ERROR)
		return
	end

	local script = M.scripts_dir .. "/" .. SCRIPTS[kind]

	if vim.fn.filereadable(script) == 0 then
		vim.notify("Error: no se encuentra " .. script, vim.log.levels.ERROR)
		return
	end

	vim.cmd("write")

	local cmd = { "python3", script, file_path }

	local output_dir = vim.fn.fnamemodify(file_path, ":p:h")
	local file_name = vim.fn.fnamemodify(file_path, ":t:r")

	run_async(cmd, output_dir, "Pandoc " .. kind .. " " .. file_name)
end

return M
