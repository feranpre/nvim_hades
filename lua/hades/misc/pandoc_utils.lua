local M = {}

function M.pandoc_to_pdf()
  -- Get the filename of the current buffer
  local filename = vim.api.nvim_buf_get_name(0)

  -- Call the shell command
  vim.fn.system("pandoc_to_pdf.py " .. vim.fn.shellescape(filename))

  -- Optionally print a message
  print("Converted " .. filename .. " to PDF")
end

function M.pandoc_to_revealjs()
  -- Get the full path of the current file
  local input_file = vim.fn.expand("%:p")
  local python_script = "pandoc_to_revealjs.py" -- Update this path

  -- Check if the file is a Markdown file
  if vim.fn.expand("%:e") ~= "md" then
    vim.notify("Current file is not a Markdown file.", vim.log.levels.ERROR)
    return
  end

  -- Build the Python command
  local command = string.format("%s %s", python_script, input_file)
  -- local command = string.format("python3 %s %s", python_script, input_file)

  -- Execute the Python script
  local result = vim.fn.system(command)
  -- local result = vim.fn.system(python_script .. " " .. input_file)

  -- Check if the command was successful
  if vim.v.shell_error == 0 then
    vim.notify("Conversion successful! Presentation opened in browser.", vim.log.levels.INFO)
  else
    vim.notify("Conversion failed:\n" .. result, vim.log.levels.ERROR)
  end
  -- -- Get the filename of the current buffer
  -- local filename = vim.api.nvim_buf_get_name(0)
  --
  -- -- Call the shell command
  -- vim.fn.system("python pandoc_to_revealjs.py " .. vim.fn.shellescape(filename))
  --
  -- -- Optionally print a message
  -- print("Converted " .. filename .. " to reveal presentation")
end
return M
