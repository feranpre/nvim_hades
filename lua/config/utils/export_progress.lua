-- config/utils/export_progress.lua
--
-- Ventana de progreso de las exportaciones (config.utils.export). Interpreta
-- las líneas "@@hades ..." que escribe por stderr scripts/hades_progress.R
-- (el perfil de R que carga md_to_pdf.py) y md_to_pdf.py:
--
--   @@hades phase render|pandoc
--   @@hades chunk <i> <total> <es_codigo> <etiqueta>
--   @@hades knit-done
--   @@hades step <i> <n> <tarea>\t<detalle>    (pasos de feR dentro de un bloque)
--   @@hades step-end
local M = {}

M.opts = {
	width = 62,
	interval = 200, -- ms entre redibujados
	stale = 20, -- segundos sin noticias de R a partir de los que se avisa
}

local uv = vim.uv or vim.loop

-- Exportaciones en curso (una ventana por cada una, apiladas)
local active = {}

local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local function now()
	return uv.hrtime() / 1e9
end

local function clock(s)
	if not s or s ~= s or s == math.huge then
		return "--:--"
	end
	s = math.max(0, math.floor(s + 0.5))
	if s >= 3600 then
		return string.format("%d:%02d:%02d", math.floor(s / 3600), math.floor(s % 3600 / 60), s % 60)
	end
	return string.format("%02d:%02d", math.floor(s / 60), s % 60)
end

local function fit(s, w)
	if vim.fn.strdisplaywidth(s) <= w then
		return s
	end
	return vim.fn.strcharpart(s, 0, w - 1) .. "…"
end

-- texto a la izquierda y a la derecha en el mismo renglón
local function lr(left, right, w)
	local gap = w - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right)
	if gap < 1 then
		return fit(left .. " " .. right, w)
	end
	return left .. string.rep(" ", gap) .. right
end

local function bar(frac, width)
	frac = math.max(0, math.min(1, frac))
	local full = math.floor(frac * width + 0.5)
	return string.rep("█", full) .. string.rep("░", width - full)
end

---------------------------------------------------------------------------
-- Estado
---------------------------------------------------------------------------

local Progress = {}
Progress.__index = Progress

function M.new(name, format)
	local p = setmetatable({
		name = name,
		format = format,
		t0 = now(),
		last = now(), -- última noticia de R
		tick = 0,
		phase = "start",
		total = nil, -- grupos de knitr (texto + código)
		i = nil, -- grupo en curso
		label = nil,
		group_start = nil,
		code_times = {}, -- duración de los bloques de código terminados
		chunks = {}, -- { label, time } de los bloques de código terminados
		current_is_code = false,
		step = nil, -- { i, n, task, detail }
		log = {}, -- últimas líneas de stderr que no son de progreso
	}, Progress)

	table.insert(active, p)

	p.timer = uv.new_timer()
	p.timer:start(0, M.opts.interval, vim.schedule_wrap(function()
		p:redraw()
	end))

	return p
end

function Progress:close_group(t)
	if self.i and self.group_start and self.current_is_code then
		local d = t - self.group_start
		table.insert(self.code_times, d)
		table.insert(self.chunks, { label = self.label, time = d })
	end
end

-- Procesa una línea de stderr de md_to_pdf.py
function Progress:feed(line)
	line = line:gsub("\27%[[%d;]*m", ""):gsub("\r", "")
	local msg = line:match("@@hades (.*)$")

	if not msg then
		if vim.trim(line) ~= "" then
			table.insert(self.log, line)
			if #self.log > 60 then
				table.remove(self.log, 1)
			end
		end
		return
	end

	local t = now()
	self.last = t

	local i, total, code, label = msg:match("^chunk (%d+) (%d+) (%d) ?(.*)$")
	if i then
		self:close_group(t)
		self.phase = "render"
		self.i, self.total = tonumber(i), tonumber(total)
		self.current_is_code = code == "1"
		self.label = label ~= "" and label or nil
		self.group_start = t
		self.step = nil
		self.group_frac = 0
		return
	end

	if msg == "knit-done" then
		self:close_group(t)
		self.phase = "document"
		self.step = nil
		return
	end

	local si, sn, task, detail = msg:match("^step (%d+) (%d+) ([^\t]*)\t?(.*)$")
	if si then
		self.step = { i = tonumber(si), n = tonumber(sn), task = task, detail = detail }
		return
	end

	if msg == "step-end" then
		-- lo que hacía feR dentro del bloque ha terminado
		self.group_frac = 1
		self.step = nil
		return
	end

	local ph = msg:match("^phase (%S+)")
	if ph then
		-- md_to_pdf.py anuncia "render" al lanzar quarto/R y "pandoc" para .md
		if ph == "pandoc" then
			self.phase = "document"
		elseif self.phase == "start" then
			self.phase = "starting-r"
		end
	end
end

-- Fracción del bloque en curso según los pasos de feR (0 si no hay)
function Progress:step_fraction()
	local s = self.step
	local f = self.group_frac or 0
	if s and s.n and s.n > 0 then
		f = math.max(f, math.max(0, math.min(1, (s.i - 1) / s.n)))
	end
	self.group_frac = f
	return f
end

-- Tiempo restante estimado (segundos) o nil si aún no se puede estimar
function Progress:remaining(t)
	if not (self.i and self.total) then
		return nil
	end

	local in_group = t - (self.group_start or t)
	local sf = self:step_fraction()

	-- media de los bloques de código terminados
	local mean
	if #self.code_times > 0 then
		local sum = 0
		for _, d in ipairs(self.code_times) do
			sum = sum + d
		end
		mean = sum / #self.code_times
	end

	-- lo que le queda al bloque en curso: por sus pasos si los hay
	local current_left
	if self.current_is_code and sf > 0.02 then
		current_left = in_group / sf * (1 - sf)
	elseif self.current_is_code and mean then
		current_left = math.max(mean - in_group, 0)
	else
		current_left = 0
	end

	-- bloques que quedan: grupos restantes por la proporción de código vista
	local seen_code = #self.code_times + (self.current_is_code and 1 or 0)
	local code_ratio = seen_code / math.max(self.i, 1)
	local groups_left = self.total - self.i
	local code_left = groups_left * code_ratio

	if not mean then
		if self.current_is_code and sf > 0.02 then
			-- sin bloques terminados: suponer que los demás duran como este
			mean = in_group / sf
		else
			return nil
		end
	end

	return current_left + code_left * mean
end

function Progress:lines()
	local w = M.opts.width
	local t = now()
	self.tick = self.tick + 1

	local spinner = SPINNER[self.tick % #SPINNER + 1]
	local lines = {}

	lines[1] = lr(spinner .. " Exportando " .. self.name .. " → " .. self.format, clock(t - self.t0), w)

	if self.phase == "start" then
		lines[2] = "preparando…"
	elseif self.phase == "starting-r" then
		lines[2] = "iniciando R y cargando paquetes…"
	elseif self.phase == "document" then
		lines[2] = bar(1, w - 5) .. " 100%"
		lines[3] = self.i and "código ejecutado; generando el documento…" or "generando el documento…"
		lines[4] = "(pandoc" .. (self.format == "pdf" and " y LaTeX" or "") .. ")"
	else
		local frac = ((self.i or 1) - 1 + (self.current_is_code and self:step_fraction() or 0)) / (self.total or 1)
		-- la barra nunca retrocede
		self.shown = math.max(self.shown or 0, frac)
		frac = self.shown
		lines[2] = bar(frac, w - 5) .. string.format(" %3d%%", math.floor(100 * frac))

		local what = self.current_is_code and ("bloque " .. (self.label or "sin nombre")) or "texto"
		lines[3] = lr(fit(string.format("%d/%d %s", self.i or 0, self.total or 0, what), w - 18),
			"en curso " .. clock(t - (self.group_start or t)), w)

		if self.step then
			local s = self.step
			local detail = s.detail ~= "" and ("  " .. s.detail) or ""
			lines[4] = fit(string.format("  %s %d/%d%s", s.task, s.i, s.n, detail), w)
		end

		local rem = self:remaining(t)
		table.insert(lines, "restante ~" .. (rem and clock(rem) or "--:-- (se estima al avanzar)"))
	end

	local quiet = t - self.last
	if self.phase ~= "start" and quiet >= M.opts.stale then
		table.insert(lines, "R sigue trabajando (sin noticias hace " .. clock(quiet) .. ")")
	end

	return lines
end

function Progress:slot()
	for k, p in ipairs(active) do
		if p == self then
			return k
		end
	end
	return 1
end

function Progress:redraw()
	if self.closed then
		return
	end

	local lines = self:lines()

	if not (self.buf and vim.api.nvim_buf_is_valid(self.buf)) then
		self.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[self.buf].bufhidden = "wipe"
	end

	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)

	-- apiladas desde abajo a la derecha (hasta 7 líneas por ventana)
	local row = vim.o.lines - vim.o.cmdheight - 2 - (self:slot() - 1) * 9

	local cfg = {
		relative = "editor",
		anchor = "SE",
		row = math.max(row, 1),
		col = vim.o.columns,
		width = M.opts.width,
		height = #lines,
		style = "minimal",
		border = "rounded",
		title = " Exportación ",
		title_pos = "left",
		focusable = false,
		zindex = 60,
	}

	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_set_config(self.win, cfg)
	else
		cfg.noautocmd = true
		self.win = vim.api.nvim_open_win(self.buf, false, cfg)
		vim.wo[self.win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"
	end
end

-- Cierra la ventana y devuelve un resumen: tiempo total y bloques lentos
function Progress:finish()
	self.closed = true

	if self.timer then
		self.timer:stop()
		self.timer:close()
		self.timer = nil
	end

	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win, true)
	end

	for k, p in ipairs(active) do
		if p == self then
			table.remove(active, k)
			break
		end
	end

	local total = now() - self.t0
	local summary = { "en " .. clock(total) }

	-- bloques más lentos, si la exportación ha tardado
	if total > 30 and #self.chunks > 1 then
		table.sort(self.chunks, function(a, b)
			return a.time > b.time
		end)
		table.insert(summary, "bloques más lentos:")
		for k = 1, math.min(3, #self.chunks) do
			local c = self.chunks[k]
			table.insert(summary, string.format("  %s  %s", clock(c.time), c.label or "sin nombre"))
		end
	end

	return summary
end

-- Texto corto para la línea de estado ("" si no hay nada en marcha)
function M.status()
	local p = active[1]
	if not p then
		return ""
	end
	if p.phase == "render" and p.i then
		return string.format("󰑮 %s %d%%", p.name, math.floor(100 * ((p.i - 1) / (p.total or 1))))
	end
	return "󰑮 " .. p.name
end

return M
