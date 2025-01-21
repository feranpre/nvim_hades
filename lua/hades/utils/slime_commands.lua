local M = {}
local function escape_pattern_char(char)
  return char:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function find_matching_pair_multi_line(start_line, start_col, open_char, close_char)
  local total_lines = vim.fn.line("$")
  local stack = 1
  local col = start_col
  local line_num = start_line

  while line_num <= total_lines do
    local line_content = vim.fn.getline(line_num)
    local line_length = #line_content

    while col <= line_length do
      local current_char = line_content:sub(col, col)
      if current_char == open_char then
        stack = stack + 1
      elseif current_char == close_char then
        stack = stack - 1
        if stack == 0 then
          return line_num, col
        end
      end
      col = col + 1
    end

    -- Move to the next line and reset the column
    line_num = line_num + 1
    col = 1
  end

  -- No match found
  return nil, nil
end

function M.send_expression_or_line()
  local current_line = vim.fn.line(".")
  local start_col = vim.fn.col(".")
  local total_lines = vim.fn.line("$") -- Get total lines in the buffer
  local line_content = vim.fn.getline(current_line)

  local open_close_pairs = {
    { open = "{", close = "}" },
    { open = '"', close = '"' },
    { open = "'", close = "'" },
    { open = "(", close = ")" }, -- Parentheses support
  }

  local found_match = false
  local end_line, end_col

  for _, pair in ipairs(open_close_pairs) do
    local open_char = escape_pattern_char(pair.open)
    local close_char = escape_pattern_char(pair.close)

    local start_col_symbol = line_content:find(open_char, start_col)
    if start_col_symbol then
      end_line, end_col = find_matching_pair_multi_line(current_line, start_col_symbol + 1, pair.open, pair.close)
      if end_line and end_col then
        found_match = true
        break
      end
    end
  end

  if found_match then
    local expression = vim.fn.getline(current_line, end_line)
    local full_command = table.concat(expression, "\n") .. "\n"
    vim.fn["slime#send"](full_command)

    -- Move the cursor to the line after the expression if not at the end of the buffer
    if end_line < total_lines then
      vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
    end
  else
    local current_content = vim.fn.getline(current_line)
    vim.fn["slime#send"](current_content .. "\n")

    -- Move the cursor to the next line if not at the end of the buffer
    if current_line < total_lines then
      vim.api.nvim_win_set_cursor(0, { current_line + 1, 0 })
    end
  end
end

return M
