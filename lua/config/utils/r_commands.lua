-- config/utils/r_commands.lua
local M = {}

local function run_async(cmd, cwd, label)
	vim.fn.jobstart(cmd, {
		cwd = cwd,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if data and #data > 0 and data[1] ~= "" then
				vim.notify("Output: " .. table.concat(data, "\n"), vim.log.levels.INFO)
			end
		end,
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

-- Renderiza el archivo con el formato por defecto declarado en el YAML (o html si es .R plano)
function M.rmarkdown_render(file_path)
	if not file_path then
		vim.notify("Error: File path not provided.", vim.log.levels.ERROR)
		return
	end

	local output_dir = vim.fn.fnamemodify(file_path, ":p:h")
	local file_name = vim.fn.fnamemodify(file_path, ":t:r")

	local cmd = string.format("Rscript -e 'rmarkdown::render(\"%s\")'", file_path)

	run_async(cmd, output_dir, "Render " .. file_name)
end

-- Renderiza forzando output_format: "html" o "pdf"
-- rmarkdown::render hace spin automático si file_path es un .R
function M.spin_r(file_path, file_format)
	if not file_path then
		vim.notify("Error: File path not provided.", vim.log.levels.ERROR)
		return
	end

	local output_dir = vim.fn.fnamemodify(file_path, ":p:h")
	local file_name = vim.fn.fnamemodify(file_path, ":t:r")

	local cmd = string.format(
		'Rscript -e \'rmarkdown::render("%s", output_format = "%s")\'',
		file_path,
		file_format .. "_document"
	)

	run_async(cmd, output_dir, "Spin " .. file_format .. " " .. file_name)
end

-- Formatear el archivo actual usando styler
function M.format()
	local buf = vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(buf)

	if file == "" then
		return
	end

	vim.cmd("write")

	local cmd = { "Rscript", "-e", string.format("styler::style_file('%s')", file) }
	local result = vim.system(cmd, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("Error ejecutando styler:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
		return
	end

	vim.cmd("edit")
	vim.notify("Archivo formateado con styler", vim.log.levels.INFO)
end

return M
