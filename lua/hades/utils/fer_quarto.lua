local M = {}

-- Get current chunk language by parsing Quarto header like ```{r} or ```{python}
function M.get_chunk_language()
  local line = vim.fn.getline(vim.fn.search("^```", "bn")) -- search backwards
  if not line then
    return nil
  end
  local lang = string.match(line, "^```%s*{(%a+)}")
  return lang
end

-- Send current paragraph or selection to appropriate REPL
function M.send_paragraph_by_lang()
  local lang = M.get_chunk_language()
  if not lang then
    return
  end

  local iron = require("iron.core")
  if lang == "r" or lang == "rscript" then
    -- iron.focus("R")
    iron.send("R", vim.fn.getline("'<", "'>")) -- visual selection
  elseif lang == "python" or lang == "py" then
    -- iron.focus("Python")
    iron.send("Python", vim.fn.getline("'<", "'>")) -- visual selection
  end
end

function M.send_line_by_lang()
  local lang = M.get_chunk_language()
  if not lang then
    return
  end

  local line = vim.fn.getline(".")
  local iron = require("iron.core")

  if lang == "r" or lang == "rscript" then
    -- iron.focus("R")
    iron.send("R", { line })
  elseif lang == "python" or lang == "py" then
    -- iron.focus("Python")
    iron.send("Python", { line })
  end
end

function M.is_code_chunk()
  local current, _ = require("otter.keeper").get_current_language_context()
  if current then
    return true
  else
    return false
  end
end

return M
