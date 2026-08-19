-- config/r.lua
local M = {}

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

local function package_root(buf)
	buf = buf or 0

	local filename = vim.api.nvim_buf_get_name(buf)

	if filename == "" then
		vim.notify("El buffer no tiene un archivo asociado", vim.log.levels.WARN)
		return nil
	end

	local root = vim.fs.root(filename, { "DESCRIPTION" })

	if not root then
		vim.notify("No se encuentra DESCRIPTION. No parece que estés dentro de un paquete R.", vim.log.levels.WARN)
		return nil
	end

	return root
end

local function run_terminal(cmd, cwd)
	cwd = cwd or package_root()

	if not cwd then
		return
	end

	-- Convertimos los argumentos a strings para mostrar el comando.
	local display_cmd = table.concat(cmd, " ")

	vim.notify("R package: " .. display_cmd, vim.log.levels.INFO)

	vim.cmd("botright new")

	local buf = vim.api.nvim_get_current_buf()

	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "terminal"

	vim.fn.termopen(cmd, {
		cwd = cwd,
		on_exit = function(_, exit_code)
			vim.schedule(function()
				if exit_code == 0 then
					vim.notify("Comando terminado correctamente", vim.log.levels.INFO)
				else
					vim.notify("El comando terminó con código " .. exit_code, vim.log.levels.ERROR)
				end
			end)
		end,
	})

	vim.cmd("startinsert")
end

local function current_test_file(buf)
	buf = buf or 0

	local root = package_root(buf)

	if not root then
		return nil
	end

	local filename = vim.api.nvim_buf_get_name(buf)

	if filename == "" then
		return nil
	end

	local relative = vim.fs.relpath(root, filename)

	if not relative then
		return nil
	end

	-- Actualmente asumimos que los archivos de código del paquete están
	-- dentro de R/.
	if not vim.startswith(relative, "R/") then
		vim.notify("El archivo abierto no está dentro del directorio R/", vim.log.levels.WARN)
		return nil
	end

	local name = vim.fs.basename(relative):gsub("%.R$", "")

	local test_file = root .. "/tests/testthat/test-" .. name .. ".R"

	return {
		root = root,
		name = name,
		path = test_file,
	}
end

---------------------------------------------------------------------------
-- Package
---------------------------------------------------------------------------

function M.package_build()
	local root = package_root()

	if not root then
		return
	end

	run_terminal({
		"R",
		"CMD",
		"build",
		".",
	}, root)
end

function M.package_check()
	local root = package_root()

	if not root then
		return
	end

	run_terminal({
		"R",
		"CMD",
		"check",
		".",
	}, root)
end

function M.package_install()
	local root = package_root()

	if not root then
		return
	end

	run_terminal({
		"R",
		"CMD",
		"INSTALL",
		".",
	}, root)
end

function M.package_load_all()
	local root = package_root()

	if not root then
		return
	end

	run_terminal({
		"Rscript",
		"-e",
		"devtools::load_all()",
	}, root)
end

function M.package_document()
	local root = package_root()

	if not root then
		return
	end

	run_terminal({
		"Rscript",
		"-e",
		'devtools::document(roclets = c("rd", "collate", "namespace", "vignette"))',
	}, root)
end

---------------------------------------------------------------------------
-- Tests
---------------------------------------------------------------------------

function M.package_new_test()
	local info = current_test_file()

	if not info then
		return
	end

	if vim.fn.filereadable(info.path) == 1 then
		vim.notify("El test ya existe: " .. info.path, vim.log.levels.WARN)
		return
	end

	vim.fn.mkdir(vim.fs.dirname(info.path), "p")

	local lines = {
		'test_that("' .. info.name .. ' works", {',
		"  ",
		"})",
	}

	vim.fn.writefile(lines, info.path)

	vim.cmd("edit " .. vim.fn.fnameescape(info.path))

	vim.notify("Test creado: " .. info.path, vim.log.levels.INFO)
end

function M.package_test_file()
	local info = current_test_file()

	if not info then
		return
	end

	if vim.fn.filereadable(info.path) ~= 1 then
		vim.notify("No existe el test: " .. info.path .. ". Usa ,bn para crearlo.", vim.log.levels.WARN)
		return
	end

	local relative = vim.fs.relpath(info.root, info.path)

	run_terminal({
		"Rscript",
		"-e",
		string.format("testthat::test_file(%s)", vim.fn.json_encode(relative)),
	}, info.root)
end

function M.package_test()
	local root = package_root()

	if not root then
		return
	end

	run_terminal({
		"Rscript",
		"-e",
		"devtools::test()",
	}, root)
end

function M.package_coverage()
	local root = package_root()

	if not root then
		return
	end

	run_terminal({
		"Rscript",
		"-e",
		"covr::package_coverage()",
	}, root)
end

return M
