local function python_to_md()
  -- Get the filename of the current buffer
  local filename = vim.api.nvim_buf_get_name(0)

  -- Ensure the filename is valid
  if filename == "" or vim.fn.filereadable(filename) == 0 then
    vim.notify("Invalid file. Please save the buffer first.", vim.log.levels.ERROR)
    return
  end

  -- Command to execute
  local command = "python_to_md.py " .. vim.fn.shellescape(filename)

  -- Notify the user that the process has started
  vim.notify("Starting Python conversion to MD: " .. filename, vim.log.levels.INFO)

  -- Run the command asynchronously
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        -- Log any stdout output for debugging or updates
        vim.notify("Output: " .. table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        -- Display errors to the user
        vim.notify("Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("MD conversion completed successfully for " .. filename, vim.log.levels.INFO)
      else
        vim.notify("MD conversion failed for " .. filename, vim.log.levels.ERROR)
      end
    end,
  })
end

vim.api.nvim_create_user_command("PythonToMd", python_to_md, {})
