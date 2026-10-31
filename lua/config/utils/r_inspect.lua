-- Ver str() / summary() (o cualquier expresión) del objeto bajo el cursor en
-- una ventana flotante, evaluando en la sesión de R de R.nvim.
--
-- Se manda a nvimcom un código R que captura la salida y la devuelve a
-- Neovim llamando a M.show() (el mismo mecanismo que usa R.nvim para dput).
local M = {}

-- Máximo de líneas que se devuelven (un str() de una lista enorme puede ser largo)
M.max_lines = 300

-- Nombre del objeto: selección visual o palabra bajo el cursor (en R el
-- punto forma parte de los nombres; también se aceptan df$col y pkg::obj)
local function object_name(visual)
	if visual then
		local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
		vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
		return vim.trim(table.concat(lines, " "))
	end

	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local pattern = "[%w%._%$:@]"

	if not line:sub(col, col):match(pattern) then
		return vim.fn.expand("<cword>")
	end

	local s, e = col, col

	while s > 1 and line:sub(s - 1, s - 1):match(pattern) do
		s = s - 1
	end

	while e < #line and line:sub(e + 1, e + 1):match(pattern) do
		e = e + 1
	end

	return (line:sub(s, e):gsub("^[:$@]+", ""):gsub("[:$@]+$", ""))
end

-- Evalúa `fun(obj)` en R y lo muestra en una ventana flotante
function M.inspect(fun, visual)
	if (vim.g.R_Nvim_status or 0) < 7 then
		vim.notify("R no está en marcha (,rs para arrancarlo)", vim.log.levels.WARN)
		return
	end

	local obj = object_name(visual)

	if not obj or obj == "" then
		return
	end

	local expr = fun .. "(" .. obj .. ")"
	M.pending_title = expr

	-- Código R en una línea y solo con comillas simples. \x12 \x13 \x14 son
	-- los mismos escapes que usa nvimcom para \, ' y los saltos de línea;
	-- \x27 es la comilla simple.
	local code = table.concat({
		"local({",
		"o <- tryCatch(utils::capture.output(" .. expr .. "),",
		"error = function(e) paste('Error:', conditionMessage(e)));",
		"if (length(o) > " .. M.max_lines .. ") o <- c(utils::head(o, " .. M.max_lines .. "), '[...]');",
		"o <- gsub('\\\\', '\\x12', o, fixed = TRUE);",
		"o <- gsub('\\x27', '\\x13', o, fixed = TRUE);",
		".C(nvimcom:::nvimcom_msg_to_nvim, paste0(",
		"'require(\\x27config.utils.r_inspect\\x27).show(\\x27',",
		"paste0(o, collapse = '\\x14'), '\\x27)'))",
		"})",
	}, " ")

	require("r.run").send_to_nvimcom("E", code)
end

-- Llamada desde R con la salida ya capturada
function M.show(txt)
	local title = M.pending_title or "R"
	txt = txt:gsub("\018", "\\"):gsub("\019", "'")
	local lines = vim.split(txt, "\020")

	local width = 20

	for _, l in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(l))
	end

	width = math.min(width + 2, math.floor(vim.o.columns * 0.8))
	local height = math.min(#lines, math.floor(vim.o.lines * 0.6))

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"
	-- Resaltado de la salida de R (lo trae R.nvim)
	vim.bo[buf].filetype = "rout"

	local win = vim.api.nvim_open_win(buf, false, {
		relative = "cursor",
		row = 1,
		col = 0,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = " " .. title .. " ",
		title_pos = "left",
	})

	vim.wo[win].wrap = false

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	-- q / <Esc> la cierran si se entra en ella (repitiendo el atajo se entra)
	for _, lhs in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", lhs, close, { buffer = buf, nowait = true })
	end

	-- Se cierra al mover el cursor en el buffer original
	vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "InsertEnter" }, {
		buffer = vim.api.nvim_get_current_buf(),
		once = true,
		callback = close,
	})

	M.last_win = win
end

-- Repetir el atajo con la ventana abierta entra en ella (para hacer scroll)
function M.focus_or(fun, visual)
	if M.last_win and vim.api.nvim_win_is_valid(M.last_win) then
		vim.api.nvim_set_current_win(M.last_win)
		return
	end

	M.inspect(fun, visual)
end

return M
