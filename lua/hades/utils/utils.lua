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

return M
