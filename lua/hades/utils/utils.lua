-- TODO: haciendo los fold, quiero hacer un fold que abra/cierre los de nivel 1,
-- nivel 2 y nivel 3
--
-- CREDIT: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/keymaps.lua
--
local M = {}

function M.load_colorscheme(opts)
  if type(opts.colorscheme) == "function" then
    opts.colorscheme()
  else
    vim.cmd.colorscheme(opts.colorscheme)
  end
end

function M.load_color_highlights(opts)
  if not opts.colors.highlight then
    return
  end

  local hl = opts.colors.highlight
  for group, settings in pairs(hl) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

function M.PandocToPDF()
  -- Get the filename of the current buffer
  local filename = vim.api.nvim_buf_get_name(0)

  -- Call the shell command
  vim.fn.system("pandoc2pdf.py " .. vim.fn.shellescape(filename))

  -- Optionally print a message
  print("Converted " .. filename .. " to PDF")
end

function M.fold_current_line(level)
  if not level then
    local line = vim.fn.getline(vim.fn.foldclosed("."))
    local fold_count = vim.v.foldend - vim.v.foldstart + 1
    return line .. " (" .. fold_count .. " lines)"
  end
end

-- Function to fold all headings of a specific level
function M.fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        M.fold_current_line()
        -- vim.cmd("normal! za")
      end
    end
  end
end

function M.fold_markdown_headings(levels)
  set_foldmethod_expr()
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

return M
