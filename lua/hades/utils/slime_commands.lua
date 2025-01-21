local M = {}

local function find_matching_pair(line, start_col, open_char, close_char)
  local stack = 1
  local col = start_col
  while line:sub(col, col) do
    vim.notify(line:sub(col, col))
    if line:sub(col, col) == open_char then
      stack = stack + 1
    elseif line:sub(col, col) == close_char then
      stack = stack - 1
      if stack == 0 then
        return col
      end
    end
    col = col + 1
  end
  return nil
end

function M.send_expression_or_line()
  local current_line = vim.fn.line(".")
  local start_col = vim.fn.col(".")
  -- local start_col = 0
  local total_lines = vim.fn.line("$")
  local line_content = vim.fn.getline(current_line)

  local open_close_pairs = {
    -- { open = "(", close = ")" },
    { open = "{", close = "}" },
    { open = '"', close = '"' },
    { open = "'", close = "'" },
  }

  local found_match = false
  local end_line, end_col

  for _, pair in ipairs(open_close_pairs) do
    local open_char = pair.open
    local close_char = pair.close

    -- print(string.find(line_content, "#", start_col))
    -- vim.notify(open_char)
    -- vim.notify(string.find(line_content, open_char, 1))

    local start_col_symbol = string.find(line_content, open_char, start_col)
    if start_col_symbol then
      end_col = find_matching_pair(line_content, start_col_symbol + 1, open_char, close_char)
      if end_col then
        found_match = true
        end_line = current_line
        vim.notify("match not in same line")
        break
      else
        for line_num = current_line + 1, total_lines do
          vim.notify("looking in line " .. line_num)
          line_content = vim.fn.getline(line_num)
          end_col = find_matching_pair(line_content, 1, open_char, close_char)
          if end_col then
            found_match = true
            end_line = line_num
            break
          end
        end
      end
    end
    if found_match then
      break
    end
  end

  if found_match then
    local expression = vim.fn.getline(current_line, end_line)
    vim.fn["slime#send"](table.concat(expression, "\n"))
  else
    local current_content = vim.fn.getline(current_line)
    vim.fn["slime#send"](current_content)
  end
end

-- function M.send_full_expression()
--   local current_line = vim.fn.line(".")
--   local start_line = current_line
--   local end_line = current_line
--   local filetype = vim.bo.filetype
--   local indentation = vim.fn.indent(current_line)
--
--   -- Detect the start of the expression
--   while start_line > 1 do
--     local prev_line = vim.fn.getline(start_line - 1)
--     if filetype == "python" then
--       if vim.fn.indent(start_line - 1) < indentation or prev_line:match("^%s*$") then
--         break
--       end
--     else
--       if prev_line:match("^%s*$") then
--         break
--       end
--     end
--     start_line = start_line - 1
--   end
--
--   -- Detect the end of the expression
--   while end_line < vim.fn.line("$") do
--     local next_line = vim.fn.getline(end_line + 1)
--     if filetype == "python" then
--       if vim.fn.indent(end_line + 1) < indentation or next_line:match("^%s*$") then
--         break
--       end
--     else
--       if next_line:match("^%s*$") then
--         break
--       end
--     end
--     end_line = end_line + 1
--   end
--
--   -- Send the expression to the REPL
--   local expression = vim.fn.getline(start_line, end_line)
--   vim.fn["slime#send"](table.concat(expression, "\n"))
-- end

-- local new_terminal_r = require("hades.utils.terminal").new_terminal_r
-- local new_terminal_python = require("hades.utils.terminal").new_terminal_python

-- local function create_and_configure_terminal()
--   -- Check if a terminal already exists in a split
--   for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     if vim.bo[buf].buftype == "terminal" then
--       print("A terminal window already exists.")
--       return
--     end
--   end
--   local current_win = vim.api.nvim_get_current_win()
--   --
--   -- Open a terminal in a vertical split taking 30% of the space
--   vim.cmd("vsplit")
--   vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.3))
--
--   vim.cmd("terminal")
--   vim.cmd("$")
--
--   -- Set the terminal buffer as the Slime target
--   vim.g.slime_default_config = {
--     jobid = vim.b.terminal_job_id,
--   }
--   vim.api.nvim_set_current_win(current_win)
--   print("Terminal created and set as Slime target.")
-- end

return M
