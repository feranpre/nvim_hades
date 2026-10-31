-- Gestión de proyectos de R (atajos en config.keymaps.project, grupo ,P).
-- Todo se hace en la raíz del proyecto: la carpeta con un .Rproj más cercana
-- hacia arriba desde la carpeta de trabajo de Neovim, o esa misma carpeta.
local M = {}

---------------------------------------------------------------------------
-- Plantillas
---------------------------------------------------------------------------

local RPROJ = [[
Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: knitr
LaTeX: XeLaTeX

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes
LineEndingConversion: Posix

UseNativePipeOperator: Yes
]]

-- lintr: valores por defecto, líneas de 120 y sin quejarse del código comentado
-- (habitual en scripts de análisis)
local LINTR = [[
linters: linters_with_defaults(
    line_length_linter(120),
    object_name_linter(styles = c("snake_case", "symbols")),
    commented_code_linter = NULL
  )
encoding: "UTF-8"
]]

-- air (formateador de R, ver lua/plugins/formatting.lua): mismo ancho que lintr
local AIR = [[
[format]
line-width = 120
indent-width = 2
indent-style = "space"
]]

local GITIGNORE = [[
# R
.Rproj.user/
.Rhistory
.RData
.Ruserdata
*.Rproj.user

# renv (la librería no se versiona; renv.lock sí)
renv/library/
renv/local/
renv/staging/

# Quarto / knitr
/.quarto/
*_cache/
*_files/
*.knit.md
*.utf8.md

# LaTeX
*.aux
*.log
*.out
*.toc

# Sistema
.DS_Store
]]

-- Estructura de carpetas típica de un análisis
local FOLDERS = {
	"data/raw",
	"data/processed",
	"R",
	"output/figures",
	"output/tables",
	"reports",
}

---------------------------------------------------------------------------
-- Utilidades
---------------------------------------------------------------------------

-- Raíz del proyecto: carpeta con .Rproj (hacia arriba) o la carpeta actual
function M.root()
	local cwd = vim.fn.getcwd()

	return vim.fs.root(cwd, function(name)
		return name:match("%.Rproj$") ~= nil
	end) or cwd
end

local function exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

-- Escribe el archivo solo si no existe. Devuelve true si lo ha creado.
local function write_new(path, content)
	if exists(path) then
		return false
	end

	vim.fn.mkdir(vim.fs.dirname(path), "p")
	vim.fn.writefile(vim.split(content, "\n", { trimempty = false }), path)

	return true
end

local function report(created, skipped, root)
	local msg = {}

	if #created > 0 then
		table.insert(msg, "Creado: " .. table.concat(created, ", "))
	end

	if #skipped > 0 then
		table.insert(msg, "Ya existía: " .. table.concat(skipped, ", "))
	end

	table.insert(msg, "en " .. vim.fn.fnamemodify(root, ":~"))

	vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO)
end

local function r_send(cmd)
	if (vim.g.R_Nvim_status or 0) < 7 then
		vim.notify("R no está en marcha (,rs para arrancarlo)", vim.log.levels.WARN)
		return
	end

	require("r.send").cmd(cmd)
end

local function r_path(path)
	return "'" .. path:gsub("\\", "/"):gsub("'", "\\'") .. "'"
end

---------------------------------------------------------------------------
-- Acciones
---------------------------------------------------------------------------

-- ,Pc: .Rproj, .lintr y air.toml en la carpeta de trabajo de Neovim
function M.create()
	local root = vim.fn.getcwd()
	local name = vim.fs.basename(root)
	local created, skipped = {}, {}

	-- Si ya hay un .Rproj (con otro nombre) no se crea otro
	local rproj = vim.fn.glob(root .. "/*.Rproj", false, true)[1] or (root .. "/" .. name .. ".Rproj")

	local files = {
		{ rproj, RPROJ },
		{ root .. "/.lintr", LINTR },
		{ root .. "/air.toml", AIR },
	}

	for _, f in ipairs(files) do
		local rel = vim.fs.basename(f[1])

		if write_new(f[1], f[2]) then
			table.insert(created, rel)
		else
			table.insert(skipped, rel)
		end
	end

	report(created, skipped, root)
end

-- ,Pd: carpetas estándar de un análisis (con .gitkeep para que git las guarde)
function M.folders()
	local root = M.root()
	local created, skipped = {}, {}

	for _, dir in ipairs(FOLDERS) do
		local path = root .. "/" .. dir

		if exists(path) then
			table.insert(skipped, dir)
		else
			vim.fn.mkdir(path, "p")
			vim.fn.writefile({}, path .. "/.gitkeep")
			table.insert(created, dir)
		end
	end

	report(created, skipped, root)
end

-- ,Pg: git init + .gitignore para R
function M.git()
	local root = M.root()
	local created, skipped = {}, {}

	if exists(root .. "/.git") then
		table.insert(skipped, ".git")
	else
		local result = vim.system({ "git", "init", "-q" }, { cwd = root, text = true }):wait()

		if result.code ~= 0 then
			vim.notify("git init falló:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
			return
		end

		table.insert(created, ".git")
	end

	if write_new(root .. "/.gitignore", GITIGNORE) then
		table.insert(created, ".gitignore")
	else
		table.insert(skipped, ".gitignore")
	end

	report(created, skipped, root)
end

-- ,Pn: nuevo script de R con cabecera #' (listo para exportar con ,ep)
function M.new_script()
	local root = M.root()
	local default_dir = exists(root .. "/R") and "R/" or ""

	vim.ui.input({ prompt = "Nuevo script (relativo al proyecto): ", default = default_dir }, function(input)
		if not input or vim.trim(input) == "" or input:match("/$") then
			return
		end

		local rel = input:match("%.[Rr]$") and input or (input .. ".R")
		local path = root .. "/" .. rel

		if exists(path) then
			vim.cmd.edit(vim.fn.fnameescape(path))
			return
		end

		local title = vim.fs.basename(rel):gsub("%.[Rr]$", ""):gsub("[_-]", " ")
		local author = vim.trim(vim.fn.system({ "git", "config", "user.name" }))

		if vim.v.shell_error ~= 0 or author == "" then
			author = vim.env.USER or ""
		end

		vim.fn.mkdir(vim.fs.dirname(path), "p")
		vim.fn.writefile({
			"#' ---",
			"#' title: \"" .. title:sub(1, 1):upper() .. title:sub(2) .. "\"",
			"#' author: \"" .. author .. "\"",
			"#' date: \"" .. os.date("%Y-%m-%d") .. "\"",
			"#' ---",
			"#'",
			"#' # Introducción",
			"#'",
			"",
			"",
		}, path)

		vim.cmd.edit(vim.fn.fnameescape(path))
		vim.api.nvim_win_set_cursor(0, { 9, 0 })
	end)
end

-- ,Pw: directorio de trabajo de R = raíz del proyecto
function M.setwd()
	r_send("setwd(" .. r_path(M.root()) .. ")")
end

-- ,Pr / ,Ps / ,PR / ,Pu: renv (entorno reproducible de paquetes)
function M.renv(action)
	local root = r_path(M.root())

	local commands = {
		init = "renv::init(project = " .. root .. ")",
		snapshot = "renv::snapshot(project = " .. root .. ")",
		restore = "renv::restore(project = " .. root .. ")",
		status = "renv::status(project = " .. root .. ")",
	}

	r_send(commands[action])
end

-- ,Pf: buscar archivos del proyecto
function M.find_files()
	require("telescope.builtin").find_files({ cwd = M.root(), prompt_title = "Proyecto: " .. vim.fs.basename(M.root()) })
end

-- ,Pl: lintr de todo el proyecto en la lista de quickfix
function M.lint_project()
	local root = M.root()
	local code = table.concat({
		"for (l in lintr::lint_dir(commandArgs(TRUE)[1]))",
		"cat(sprintf('%s:%d:%d: %s: %s\\n', l$filename, l$line_number, l$column_number,",
		"switch(l$type, error = 'E', warning = 'W', 'I'), gsub('\\n', ' ', l$message)))",
	}, " ")

	vim.notify("lintr: revisando el proyecto...", vim.log.levels.INFO)

	vim.system({ "Rscript", "--no-save", "--no-restore", "-e", code, root }, { cwd = root, text = true }, function(res)
		vim.schedule(function()
			local lines = vim.split(vim.trim(res.stdout or ""), "\n", { trimempty = true })

			if res.code ~= 0 and #lines == 0 then
				vim.notify("lintr falló:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
				return
			end

			vim.fn.setqflist({}, " ", {
				title = "lintr " .. vim.fs.basename(root),
				lines = lines,
				efm = "%f:%l:%c: %t: %m",
			})

			if #lines == 0 then
				vim.notify("lintr: sin avisos", vim.log.levels.INFO)
			else
				vim.cmd("botright copen")
			end
		end)
	end)
end

return M
