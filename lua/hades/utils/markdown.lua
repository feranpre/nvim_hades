-- vim.api.nvim_create_user_command("MdToPdf", function()
--   local file = vim.api.nvim_buf_get_name(0)
--   vim.fn.system({ "python3", "/path/to/md_to_pdf.py", file })
--   print("Converted " .. file .. " to PDF.")
-- end, {})
--

vim.api.nvim_create_user_command("MdToPdf", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file name detected!", vim.log.levels.ERROR)
    return
  end

  local cmd = { "md_to_pdf.py", file }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = "md_to_pdf" })
        print(table.concat(data, "\n"), vim.log.levels.INFO, { title = "md_to_pdf" })
      end
    end,

    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR, { title = "md_to_pdf (error)" })
        print(table.concat(data, "\n"), vim.log.levels.ERROR, { title = "md_to_pdf (error)" })
      end
    end,

    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Conversion completed successfully!", vim.log.levels.INFO, { title = "md_to_pdf" })
      else
        vim.notify("Conversion failed (exit code " .. code .. ")", vim.log.levels.ERROR, { title = "md_to_pdf" })
        print("Conversion failed (exit code " .. code .. ")", vim.log.levels.ERROR, { title = "md_to_pdf" })
      end
    end,
  })
end, {})
