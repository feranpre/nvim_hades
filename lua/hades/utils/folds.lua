local M = {}
function M.my_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  return " ⚡ " .. line .. ": " .. line_count .. " lines"
end

function M.fold_current_line()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  if vim.fn.foldclosed(line) == -1 then
    -- print("Folding linea " .. tostring(line))
    --   -- M.fold_current_line()
    vim.cmd("normal! zc")
  end
end

-- Function to fold all headings of a specific level
function M.fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  text_level = string.rep("#", level)

  -- vim.notify("Folding " .. text_level, vim.log.levels.INFO)
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. text_level .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        -- print("Folding linea " .. tostring(line))
        --   -- M.fold_current_line()
        vim.cmd("normal! zc")
      end
    end
  end
end

function M.fold_markdown_headings(levels)
  if not levels then
    return
  end
  -- vim.cmd("edit!")
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()

  -- levels = table.pack(levels)
  if type(levels) ~= "table" then
    levels = { levels }
  end

  vim.cmd("normal! zR")
  for _, level in ipairs(levels) do
    -- vim.notify("Folding " .. tostring(level), vim.log.levels.INFO)
    M.fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")

  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)

  vim.cmd("normal! zz") -- center the cursor line on screen
end

return M
