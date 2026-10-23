-- Presentaciones de clase con Quarto + reveal.js
-- Plantilla en <config>/scripts/templates/slides
local M = {}

M.template_dir = vim.fn.stdpath("config") .. "/scripts/templates/slides"

-- Archivos de la plantilla que se copian junto a la presentación
local SUPPORT_FILES = {
	"hades.scss",
	"img/ejemplo.svg",
}

local function slug(text)
	text = vim.fn.tolower(text)
	text = vim.fn.substitute(text, "[áàä]", "a", "g")
	text = vim.fn.substitute(text, "[éèë]", "e", "g")
	text = vim.fn.substitute(text, "[íìï]", "i", "g")
	text = vim.fn.substitute(text, "[óòö]", "o", "g")
	text = vim.fn.substitute(text, "[úùü]", "u", "g")
	text = vim.fn.substitute(text, "ñ", "n", "g")
	text = text:gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")

	return text ~= "" and text or "presentacion"
end

local function author()
	local name = vim.trim(vim.fn.system({ "git", "config", "user.name" }))

	if vim.v.shell_error ~= 0 or name == "" then
		name = vim.env.USER or "Autor"
	end

	return name
end

local function create(title, dir)
	dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":p"):gsub("/$", "")

	local qmd = dir .. "/" .. slug(title) .. ".qmd"

	if vim.uv.fs_stat(qmd) then
		vim.notify("Ya existe " .. qmd, vim.log.levels.ERROR)
		return
	end

	vim.fn.mkdir(dir .. "/img", "p")

	-- No pisar un hades.scss o imagen que ya estén en la carpeta
	for _, file in ipairs(SUPPORT_FILES) do
		if not vim.uv.fs_stat(dir .. "/" .. file) then
			vim.uv.fs_copyfile(M.template_dir .. "/" .. file, dir .. "/" .. file)
		end
	end

	-- Van entre comillas dobles en el YAML
	local values = {
		title = title:gsub('"', '\\"'),
		author = author(),
		date = os.date("%Y-%m-%d"),
	}

	local lines = vim.fn.readfile(M.template_dir .. "/clase.qmd")

	for i, line in ipairs(lines) do
		lines[i] = line:gsub("{{(%w+)}}", function(key)
			return values[key]
		end)
	end

	vim.fn.writefile(lines, qmd)
	vim.cmd.edit(vim.fn.fnameescape(qmd))
end

-- Nueva presentación a partir de la plantilla, en su propia carpeta
function M.new()
	vim.ui.input({ prompt = "Título: " }, function(title)
		if not title or vim.trim(title) == "" then
			return
		end

		title = vim.trim(title)

		vim.ui.input({
			prompt = "Carpeta: ",
			default = vim.fn.getcwd() .. "/" .. slug(title),
			completion = "dir",
		}, function(dir)
			if dir and dir ~= "" then
				create(title, dir)
			end
		end)
	end)
end

---------------------------------------------------------------------------
-- Exportar
---------------------------------------------------------------------------

-- Ejecuta los comandos en orden; quarto y decktape escriben el progreso en
-- stderr, así que solo se muestra si algo falla.
local function run_steps(steps, cwd, label, on_done)
	local step = table.remove(steps, 1)

	if not step then
		vim.notify(label .. " OK", vim.log.levels.INFO)

		if on_done then
			on_done()
		end

		return
	end

	local output = {}

	local function collect(_, data)
		vim.list_extend(output, data or {})
	end

	vim.fn.jobstart(step, {
		cwd = cwd,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = collect,
		on_stderr = collect,
		on_exit = function(_, code)
			if code ~= 0 then
				output = vim.tbl_filter(function(line)
					return line ~= ""
				end, output)

				vim.notify(
					label .. " ERROR\n" .. table.concat(vim.list_slice(output, math.max(1, #output - 15)), "\n"),
					vim.log.levels.ERROR
				)

				return
			end

			run_steps(steps, cwd, label, on_done)
		end,
	})
end

local function current_qmd()
	local file = vim.api.nvim_buf_get_name(0)

	if not file:match("%.qmd$") then
		vim.notify("El buffer no es un .qmd", vim.log.levels.WARN)
		return nil
	end

	vim.cmd("write")

	return file
end

local function render_cmd(file)
	return { "quarto", "render", file, "--to", "revealjs" }
end

-- Tamaño de las diapositivas según el YAML (width/height), 1280x720 si no está
local function slide_size(file)
	local width, height = 1280, 720

	for _, line in ipairs(vim.fn.readfile(file, "", 60)) do
		width = tonumber(line:match("^%s*width:%s*(%d+)")) or width
		height = tonumber(line:match("^%s*height:%s*(%d+)")) or height
	end

	return width .. "x" .. height
end

local function decktape_cmd()
	if vim.fn.executable("decktape") == 1 then
		return { "decktape" }
	end

	if vim.fn.executable("npx") == 1 then
		return { "npx", "--yes", "decktape" }
	end

	return nil
end

-- Genera el .html (un solo archivo, sirve sin internet)
function M.html()
	local file = current_qmd()

	if not file then
		return
	end

	local name = vim.fn.fnamemodify(file, ":t:r")

	vim.notify("Slides html " .. name .. "...", vim.log.levels.INFO)
	run_steps({ render_cmd(file) }, vim.fn.fnamemodify(file, ":h"), "Slides html " .. name)
end

-- Genera el .html y lo convierte a PDF con decktape
function M.pdf()
	local file = current_qmd()

	if not file then
		return
	end

	local decktape = decktape_cmd()

	if not decktape then
		vim.notify("Falta decktape: npm install -g decktape", vim.log.levels.ERROR)
		return
	end

	local name = vim.fn.fnamemodify(file, ":t:r")
	local html = vim.fn.fnamemodify(file, ":r") .. ".html"
	local pdf = vim.fn.fnamemodify(file, ":r") .. ".pdf"

	local export = vim.list_extend(decktape, { "reveal", "--size", slide_size(file), html, pdf })

	vim.notify("Slides pdf " .. name .. "...", vim.log.levels.INFO)
	run_steps({ render_cmd(file), export }, vim.fn.fnamemodify(file, ":h"), "Slides pdf " .. name)
end

return M
