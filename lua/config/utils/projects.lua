-- config/utils/projects.lua
--
-- Proyectos: cada proyecto es una carpeta. Se guarda una lista de los
-- recientes (stdpath("data")/hades_projects.json) que aparece en la portada,
-- en <leader>p y en :Projects.
--
-- Abrir un proyecto:
--   - cambia el directorio de trabajo de Neovim a su carpeta;
--   - si es de R, cambia también el de R (setwd) si R está en marcha; si no,
--     R arrancará ya en esa carpeta (setwd = "nvim" en lua/plugins/r.lua);
--   - abre el último archivo editado del proyecto, o la carpeta (oil).
local M = {}

M.store = vim.fs.joinpath(vim.fn.stdpath("data"), "hades_projects.json")

-- Carpeta donde se crean los proyectos nuevos (se puede cambiar al crearlo)
M.default_dir = (Hades and Hades.projects_dir) or "~/Proyectos"

local MAX = 50

---------------------------------------------------------------------------
-- Lista de recientes
---------------------------------------------------------------------------

local function normalize(path)
	path = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(path), ":p"))
	return (path:gsub("/$", ""))
end

local function is_dir(path)
	local stat = vim.uv.fs_stat(path)
	return stat ~= nil and stat.type == "directory"
end

local function read()
	local fd = io.open(M.store, "r")

	if not fd then
		return {}
	end

	local ok, data = pcall(vim.json.decode, fd:read("*a"))
	fd:close()

	return ok and type(data) == "table" and data or {}
end

local function write(list)
	vim.fn.mkdir(vim.fs.dirname(M.store), "p")

	local fd = io.open(M.store, "w")

	if fd then
		fd:write(vim.json.encode(list))
		fd:close()
	end
end

-- Proyectos recientes que todavía existen, del más reciente al más antiguo
---@return { path: string, last: integer }[]
function M.list()
	local list = vim.tbl_filter(function(p)
		return type(p) == "table" and type(p.path) == "string" and is_dir(p.path)
	end, read())

	table.sort(list, function(a, b)
		return (a.last or 0) > (b.last or 0)
	end)

	return list
end

---@return string[]
function M.paths()
	return vim.tbl_map(function(p)
		return p.path
	end, M.list())
end

-- Añade (o sube al principio) un proyecto
function M.add(path)
	path = normalize(path)

	local list = vim.tbl_filter(function(p)
		return p.path ~= path
	end, M.list())

	table.insert(list, 1, { path = path, last = os.time() })
	write(vim.list_slice(list, 1, MAX))
end

-- Quita un proyecto de la lista (la carpeta no se toca)
function M.forget(path)
	path = normalize(path)

	write(vim.tbl_filter(function(p)
		return p.path ~= path
	end, M.list()))
end

---------------------------------------------------------------------------
-- Abrir
---------------------------------------------------------------------------

-- ¿Es un proyecto de R? .Rproj, paquete, renv o scripts de R en la raíz
function M.is_r(path)
	for _, pattern in ipairs({ "*.Rproj", "DESCRIPTION", "renv.lock", ".Rprofile", "*.[Rr]", "*.[Rr]md", "*.qmd" }) do
		if #vim.fn.glob(path .. "/" .. pattern, true, true) > 0 then
			return true
		end
	end

	return false
end

local function r_running()
	return (vim.g.R_Nvim_status or 0) >= 7
end

local function r_setwd(path)
	local quoted = "'" .. path:gsub("\\", "/"):gsub("'", "\\'") .. "'"
	require("r.send").cmd("setwd(" .. quoted .. ")")
end

-- Último archivo editado dentro del proyecto (de :oldfiles)
local function last_file(path)
	local prefix = path .. "/"

	for _, file in ipairs(vim.v.oldfiles) do
		local f = vim.fs.normalize(file)

		if vim.startswith(f, prefix) and not f:find("/%.git/") and vim.fn.filereadable(f) == 1 then
			return f
		end
	end
end

---@param path string
---@param opts? { file?: boolean }  file = false: no abrir ningún archivo
function M.open(path, opts)
	opts = opts or {}
	path = normalize(path)

	if not is_dir(path) then
		vim.notify("No existe la carpeta " .. path, vim.log.levels.ERROR)
		M.forget(path)
		return
	end

	vim.cmd.cd(vim.fn.fnameescape(path))
	M.add(path)

	local msg = "Proyecto: " .. vim.fn.fnamemodify(path, ":~")

	if M.is_r(path) then
		if r_running() then
			r_setwd(path)
			msg = msg .. "\nR: setwd() a la carpeta del proyecto"
		else
			msg = msg .. "\nR arrancará en la carpeta del proyecto"
		end
	end

	vim.notify(msg, vim.log.levels.INFO)

	if opts.file == false then
		return
	end

	local file = last_file(path)

	if file then
		vim.cmd.edit(vim.fn.fnameescape(file))
	elseif pcall(require, "oil") then
		require("oil").open(path)
	else
		vim.cmd.edit(vim.fn.fnameescape(path))
	end
end

---------------------------------------------------------------------------
-- Crear
---------------------------------------------------------------------------

local KINDS = {
	{
		id = "analisis",
		label = "Análisis de R (.Rproj, .lintr, air.toml, carpetas DATOS_*, git)",
	},
	{ id = "r", label = "R básico (.Rproj, .lintr, air.toml)" },
	{ id = "vacio", label = "Carpeta vacía" },
}

local function setup_kind(kind)
	local rp = require("config.utils.r_project")

	if kind == "analisis" or kind == "r" then
		rp.create()
	end

	if kind == "analisis" then
		rp.folders()

		if vim.fn.executable("git") == 1 then
			rp.git()
		end
	end
end

-- Crea una carpeta de proyecto nueva y la abre
function M.new()
	local base = vim.fn.fnamemodify(vim.fn.expand(M.default_dir), ":~") .. "/"

	vim.ui.input({ prompt = "Nuevo proyecto (carpeta): ", default = base, completion = "dir" }, function(input)
		if not input or vim.trim(input) == "" or normalize(input) == normalize(base) then
			return
		end

		local path = normalize(input)

		vim.ui.select(KINDS, {
			prompt = "Tipo de proyecto",
			format_item = function(k)
				return k.label
			end,
		}, function(kind)
			if not kind then
				return
			end

			local existed = is_dir(path)

			if vim.fn.mkdir(path, "p") == 0 and not existed then
				vim.notify("No se pudo crear " .. path, vim.log.levels.ERROR)
				return
			end

			-- r_project trabaja en el cwd: primero se cambia de carpeta, se
			-- crean los archivos y luego se abre (ya se sabe si es de R)
			vim.cmd.cd(vim.fn.fnameescape(path))
			setup_kind(kind.id)
			M.open(path, { file = false })

			if pcall(require, "oil") then
				require("oil").open(path)
			end
		end)
	end)
end

-- Añade la carpeta actual a la lista de proyectos
function M.add_current()
	local cwd = vim.fn.getcwd()
	M.add(cwd)
	vim.notify("Añadido a proyectos: " .. vim.fn.fnamemodify(cwd, ":~"), vim.log.levels.INFO)
end

---------------------------------------------------------------------------
-- Selector (telescope)
---------------------------------------------------------------------------

local function ago(t)
	local d = os.time() - (t or 0)

	if d < 3600 then
		return "hace " .. math.max(1, math.floor(d / 60)) .. " min"
	elseif d < 86400 then
		return "hace " .. math.floor(d / 3600) .. " h"
	elseif d < 86400 * 30 then
		return "hace " .. math.floor(d / 86400) .. " d"
	end

	return os.date("%d/%m/%Y", t)
end

-- <CR> abrir · <C-n> nuevo · <C-x> quitar de la lista · <C-a> añadir la carpeta actual
function M.pick()
	local ok = pcall(require, "telescope")

	if not ok then
		vim.ui.select(M.paths(), { prompt = "Proyectos" }, function(p)
			if p then
				M.open(p)
			end
		end)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local state = require("telescope.actions.state")
	local entry_display = require("telescope.pickers.entry_display")

	local displayer = entry_display.create({
		separator = " ",
		items = { { width = 2 }, { width = 28 }, { width = 14 }, { remaining = true } },
	})

	local function finder()
		return finders.new_table({
			results = M.list(),
			entry_maker = function(p)
				local name = vim.fs.basename(p.path)
				local r = M.is_r(p.path)

				return {
					value = p.path,
					ordinal = name .. " " .. p.path,
					display = function()
						return displayer({
							{ r and "󰟔" or "", r and "Special" or "Directory" },
							name,
							{ ago(p.last), "Comment" },
							{ vim.fn.fnamemodify(p.path, ":~:h"), "Comment" },
						})
					end,
				}
			end,
		})
	end

	pickers
		.new({}, {
			prompt_title = "Proyectos  (<C-n> nuevo · <C-x> quitar · <C-a> añadir carpeta actual)",
			finder = finder(),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(bufnr, map)
				actions.select_default:replace(function()
					local entry = state.get_selected_entry()
					actions.close(bufnr)

					if entry then
						M.open(entry.value)
					end
				end)

				map({ "i", "n" }, "<C-n>", function()
					actions.close(bufnr)
					M.new()
				end)

				map({ "i", "n" }, "<C-x>", function()
					local entry = state.get_selected_entry()

					if entry then
						M.forget(entry.value)
						state.get_current_picker(bufnr):refresh(finder(), { reset_prompt = false })
					end
				end)

				map({ "i", "n" }, "<C-a>", function()
					M.add_current()
					state.get_current_picker(bufnr):refresh(finder(), { reset_prompt = false })
				end)

				return true
			end,
		})
		:find()
end

---------------------------------------------------------------------------
-- Comandos y registro automático
---------------------------------------------------------------------------

function M.setup()
	vim.api.nvim_create_user_command("Projects", function()
		M.pick()
	end, { desc = "Proyectos recientes" })

	vim.api.nvim_create_user_command("ProjectNew", function()
		M.new()
	end, { desc = "Crear un proyecto nuevo" })

	vim.api.nvim_create_user_command("ProjectAdd", function()
		M.add_current()
	end, { desc = "Añadir la carpeta actual a los proyectos" })

	vim.api.nvim_create_user_command("ProjectOpen", function(cmd)
		M.open(cmd.args)
	end, { nargs = 1, complete = "dir", desc = "Abrir una carpeta como proyecto" })

	-- Si Neovim se abre dentro de un proyecto de R (p. ej. `nvim` en la
	-- carpeta), se apunta en la lista de recientes
	vim.api.nvim_create_autocmd("VimEnter", {
		group = vim.api.nvim_create_augroup("HadesProjects", { clear = true }),
		callback = function()
			local cwd = vim.fn.getcwd()

			if #vim.fn.glob(cwd .. "/*.Rproj", true, true) > 0 then
				M.add(cwd)
			end
		end,
	})
end

return M
