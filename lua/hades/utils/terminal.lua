local M = {}

function M.new_terminal(lang, prop)
  if not lang then
    lang = "$SHELL"
  end
  if not prop then
    prop = 0.3
  end
  print(lang)
  print(tostring(prop))

  local current_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit")
  vim.cmd("vertical resize " .. math.floor(vim.o.columns * prop))
  vim.cmd("terminal " .. lang)
  vim.api.nvim_set_current_win(current_win)
end

function M.new_terminal_python()
  M.new_terminal("python")
end

function M.new_terminal_r()
  -- vim.b["quarto_is_r_mode"] = true
  M.new_terminal("R --no-save")
end

function M.new_terminal_ipython()
  M.new_terminal("ipython --no-confirm-exit")
end

function M.new_terminal_julia()
  M.new_terminal("julia")
end

function M.new_terminal_shell()
  M.new_terminal("$SHELL")
end

return M
