local keys = require("config.utils.keymaps")

-- Gestión de proyectos de R (config.utils.r_project). Globales: funcionan
-- desde cualquier buffer, también desde la portada.
local function project(fn, ...)
	local args = { ... }

	return function()
		require("config.utils.r_project")[fn](unpack(args))
	end
end

keys.group("n", "<localleader>P", "[P]roject")

-- Proyectos (config.utils.projects): lista de recientes y crear carpetas nuevas
local function projects(fn)
	return function()
		require("config.utils.projects")[fn]()
	end
end

keys.map("n", "<leader>p", projects("pick"), "[p]royectos recientes")
keys.map("n", "<localleader>Pp", projects("pick"), "[p]royectos recientes (abrir)")
keys.map("n", "<localleader>PN", projects("new"), "[N]uevo proyecto (carpeta)")
keys.map("n", "<localleader>Pa", projects("add_current"), "[a]ñadir carpeta actual a proyectos")

keys.map("n", "<localleader>Pc", project("create"), "[c]reate project (.Rproj, .lintr, air.toml)")
keys.map("n", "<localleader>Pd", project("folders"), "create [d]irectories (DATOS_BASE, DATOS_R...)")
keys.map("n", "<localleader>Pg", project("git"), "[g]it init + .gitignore")
keys.map("n", "<localleader>Pn", project("new_script"), "[n]ew R script")
keys.map("n", "<localleader>Pf", project("find_files"), "[f]ind project files")
keys.map("n", "<localleader>Pl", project("lint_project"), "[l]int project (quickfix)")
keys.map("n", "<localleader>Pw", project("setwd"), "R [w]orking dir = project")

keys.map("n", "<localleader>Pr", project("renv", "init"), "[r]env init")
keys.map("n", "<localleader>Ps", project("renv", "snapshot"), "renv [s]napshot")
keys.map("n", "<localleader>PR", project("renv", "restore"), "renv [R]estore")
keys.map("n", "<localleader>Pu", project("renv", "status"), "renv stat[u]s")
