-- config/utils/r_compl.lua
--
-- :RRebuildCompl [paquete]  (feR por defecto) / ,rC en los archivos de R
--
-- Rehace la lista de autocompletado de R.nvim de un paquete que se ha
-- reinstalado SIN cambiar de versión (p. ej. feR en desarrollo tras
-- devtools::install()). R.nvim solo rehace esas listas cuando cambia la
-- versión del paquete, así que las funciones nuevas no aparecen.
--
-- 1. En un proceso de R aparte (lee el paquete recién instalado, no el que
--    pueda tener cargado la consola) se borran y se rehacen los archivos de
--    caché del paquete con las mismas funciones que usa R.nvim (nvimcom):
--    objls_<pkg>_<versión>, alias_<pkg>, args_<pkg> y srcref_<pkg>.
-- 2. Si el servidor de autocompletado de R.nvim (r_ls) está en marcha, tiene
--    la lista vieja en memoria y solo la vuelve a leer si ve otra versión: se
--    deja un momento una copia con una versión ficticia ("<versión>-hades"),
--    se le pide que relea la caché (el mismo aviso que manda R.nvim al
--    terminar de construirla) y se borra la copia.
local M = {}

M.default_pkg = "feR"

local R_CODE = [[
args <- commandArgs(TRUE)
pkg <- args[1]
dir <- args[2]
Sys.setenv(RNVIM_COMPLDIR = dir)
options(nvimcom.verbose = 0)
suppressMessages(library("nvimcom", character.only = TRUE, warn.conflicts = FALSE,
                         quietly = TRUE, mask.ok = "vi"))
if (!requireNamespace(pkg, quietly = TRUE)) {
  stop("el paquete '", pkg, "' no está instalado", call. = FALSE)
}
v <- as.character(utils::packageVersion(pkg))
old <- list.files(dir, paste0("^objls_", pkg, "_"), full.names = TRUE)
unlink(c(old, file.path(dir, paste0(c("alias_", "args_", "srcref_"), pkg))))
objls <- file.path(dir, paste0("objls_", pkg, "_", v))
nvimcom:::nvim.bol(objls, pkg)
nvimcom:::nvim.buildargs(file.path(dir, paste0("args_", pkg)), pkg)
nvimcom:::nvim.build.srcref(file.path(dir, paste0("srcref_", pkg)), pkg)
if (!file.exists(objls)) stop("no se pudo crear ", objls, call. = FALSE)
cat("HADES_VERSION:", v, "\n", sep = "")
]]

local function r_config()
	local ok, rc = pcall(require, "r.config")
	return ok and rc.get_config() or nil
end

local function server()
	return vim.lsp.get_clients({ name = "r_ls" })[1]
end

-- Hace que r_ls relea la caché del paquete aunque tenga la misma versión
local function reload_server(dir, pkg, version)
	local client = server()

	if not client then
		return false
	end

	local real = vim.fs.joinpath(dir, ("objls_%s_%s"):format(pkg, version))
	local fake = real .. "-hades"

	if not vim.uv.fs_copyfile(real, fake) then
		return false
	end

	-- "41": releer la caché (finish_updating_loaded_libs en rnvimserver)
	client:notify("exeRnvimCmd", { code = "41" })

	-- La copia ya no hace falta: si se quedara, R.nvim la tomaría por una
	-- versión antigua y rehará la lista del paquete al arrancar
	vim.defer_fn(function()
		vim.uv.fs_unlink(fake)
	end, 3000)

	return true
end

---@param pkg? string
function M.rebuild(pkg)
	pkg = (pkg and pkg ~= "") and pkg or M.default_pkg

	local cfg = r_config()

	if not cfg then
		vim.notify("R.nvim no está cargado", vim.log.levels.ERROR)
		return
	end

	if cfg.remote_R_host and cfg.remote_R_host ~= "" then
		vim.notify("RRebuildCompl no funciona con R remoto", vim.log.levels.WARN)
		return
	end

	local dir = cfg.compldir

	if not dir or dir == "" or vim.fn.isdirectory(dir) == 0 then
		vim.notify("No se encuentra la caché de R.nvim (compldir)", vim.log.levels.ERROR)
		return
	end

	local script = vim.fn.tempname() .. ".R"
	vim.fn.writefile(vim.split(R_CODE, "\n"), script)

	local R = (cfg.R_cmd and cfg.R_cmd ~= "") and cfg.R_cmd or "R"

	vim.notify("Reconstruyendo el autocompletado de " .. pkg .. "...", vim.log.levels.INFO)

	vim.system(
		{ R, "--quiet", "--no-save", "--no-restore", "--slave", "-f", script, "--args", pkg, dir },
		{ text = true, env = { RNVIM_COMPLDIR = dir } },
		function(res)
			vim.schedule(function()
				os.remove(script)

				local version = (res.stdout or ""):match("HADES_VERSION:([^\n]+)")

				if res.code ~= 0 or not version then
					local err = vim.trim((res.stderr or "") .. "\n" .. (res.stdout or ""))
					vim.notify("No se pudo rehacer el autocompletado de " .. pkg .. ":\n" .. err, vim.log.levels.ERROR)
					return
				end

				version = vim.trim(version)

				local msg = ("Autocompletado de %s %s rehecho"):format(pkg, version)

				if reload_server(dir, pkg, version) then
					msg = msg .. "; ya se ven las funciones nuevas"
				else
					msg = msg .. "; se usará al arrancar R"
				end

				vim.notify(msg, vim.log.levels.INFO)
			end)
		end
	)
end

function M.create_command()
	vim.api.nvim_create_user_command("RRebuildCompl", function(o)
		M.rebuild(o.args)
	end, {
		nargs = "?",
		desc = "Rehacer la lista de autocompletado de R de un paquete (feR por defecto)",
	})
end

return M
