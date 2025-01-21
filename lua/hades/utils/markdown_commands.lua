-- local M = {}

-- local function md_to_pdf()
--   -- Get the filename of the current buffer
--   local filename = vim.api.nvim_buf_get_name(0)
--
--   -- Call the shell command
--   vim.fn.system("md_to_pdf.py " .. vim.fn.shellescape(filename))
--
--   -- Optionally print a message
--   print("Converted " .. filename .. " to PDF")
-- end

local function md_to_pdf()
  -- Get the filename of the current buffer
  local filename = vim.api.nvim_buf_get_name(0)

  -- Ensure the filename is valid
  if filename == "" or vim.fn.filereadable(filename) == 0 then
    vim.notify("Invalid file. Please save the buffer first.", vim.log.levels.ERROR)
    return
  end

  -- Command to execute
  local command = "md_to_pdf.py " .. vim.fn.shellescape(filename)

  -- Notify the user that the process has started
  vim.notify("Starting PDF conversion for " .. filename, vim.log.levels.INFO)

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
        vim.notify("PDF conversion completed successfully for " .. filename, vim.log.levels.INFO)
      else
        vim.notify("PDF conversion failed for " .. filename, vim.log.levels.ERROR)
      end
    end,
  })
end

local function md_number_headings()
  -- Save the current cursor position
  local save_cursor = vim.fn.getpos(".")

  -- Get the current buffer content as a single string
  local lines = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

  -- Run number headings first
  local command = "md_number_headings.py"
  local output_numeration = vim.fn.system(command, lines)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error running md_number_headings.py:\n" .. output_numeration, vim.log.levels.ERROR)
    return
  end

  -- Run number headings first
  command = "md_headers_id.py"
  local output_id_tags = vim.fn.system(command, output_numeration)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error running md_headers_id.py:\n" .. output_id_tags, vim.log.levels.ERROR)
    return
  end

  -- Replace the buffer content with the processed output
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output_id_tags, "\n"))

  -- Restore the cursor position
  vim.fn.setpos(".", save_cursor)
end

local function md_remove_number_headings()
  -- Save the current cursor position
  local save_cursor = vim.fn.getpos(".")

  -- Get the current buffer content as a single string
  local lines = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

  -- Run number headings first
  local command = "md_remove_number_headings.py"
  local output_numeration = vim.fn.system(command, lines)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error running md_remove_number_headings.py:\n" .. output_numeration, vim.log.levels.ERROR)
    return
  end

  -- Run number headings first
  local command = "md_headers_id.py"
  local output_id_tags = vim.fn.system(command, output_numeration)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error running md_headers_id.py:\n" .. output_id_tags, vim.log.levels.ERROR)
    return
  end

  -- Replace the buffer content with the processed output
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output_id_tags, "\n"))

  -- Restore the cursor position
  vim.fn.setpos(".", save_cursor)
end

local function md_generate_toc(max_level)
  -- Save the current cursor position
  local save_cursor = vim.fn.getpos(".")

  -- Prompt for max level if not provided
  if not max_level then
    max_level = vim.fn.input("Enter max heading level for TOC (default 3): ", "3")
    max_level = tonumber(max_level) or 3
  end

  -- Get the current buffer content as a single string
  local lines = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

  -- Define the shell command with the Python script
  -- local command = string.format("md_toc.py -m %d", max_level)
  -- local command = string.format("md_generate_toc.py -m %d", max_level)
  local command = string.format("md_generate_toc.py %d", max_level)

  -- Use `vim.fn.system` to execute the command and pass the content
  local toc = vim.fn.system(command, lines)

  -- Check for errors in the script execution
  if vim.v.shell_error ~= 0 then
    vim.notify("Error running md_toc.py:\n" .. toc, vim.log.levels.ERROR)
    return
  end

  -- Insert the TOC at the current cursor position
  local cursor_line = save_cursor[2]
  vim.api.nvim_buf_set_lines(0, cursor_line - 1, cursor_line - 1, false, vim.split(toc, "\n"))

  -- Restore the cursor position
  vim.fn.setpos(".", save_cursor)
end

local function md_jump_to_toc_link()
  -- Get the word under the cursor
  local current_word = vim.fn.expand("<cword>")

  -- Remove the `#` at the start and decode the anchor format
  local anchor = current_word:gsub("^#", "")

  -- Convert dashes to spaces for matching
  local search_text = anchor:gsub("-", " ")

  -- Use `/` search to find the corresponding heading in the buffer
  local found = vim.fn.search("\\v^#{1,6}\\s+" .. vim.fn.escape(search_text, "\\/"), "W")

  -- Notify the user if no match is found
  if found == 0 then
    vim.notify("No matching heading found for " .. current_word, vim.log.levels.WARN)
  end
end

--
-- CUSTOM COMMANDS --
--

vim.api.nvim_create_user_command("MdNumberHeadings", md_number_headings, {})

vim.api.nvim_create_user_command("MdRemoveNumberHeadings", md_remove_number_headings, {})
vim.api.nvim_create_user_command(
  "MdGenerateTOC",
  function(opts)
    md_generate_toc(tonumber(opts.args) or nil)
  end,
  { nargs = "?" } -- Allow an optional argument
)

vim.api.nvim_create_user_command("MdToPDF", md_to_pdf, {})

vim.api.nvim_create_user_command("MdJumpToTOCLink", md_jump_to_toc_link, {})

-- return M
