local M = {}
--
-- Test if module is loaded
--
function M.isModuleAvailable(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.loaders) do
      local loader = searcher(name)
      print()
      if type(loader) == "function" then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

function M.isModuleInstalled(name)
  local ok, _ = pcall(require, name)
  return ok
end

function M.keymap(mode, keys, func, opts, desc)
  local local_opts = opts
  if desc then
    local_opts["desc"] = desc
  end
  -- vim.api.nvim_set_keymap(mode, keys, func, local_opts)
  vim.keymap.set(mode, keys, func, local_opts)
end

function M.keymap_buffer(buffer, mode, keys, func, opts, desc)
  local local_opts = opts
  local_opts["buffer"] = buffer
  if desc then
    local_opts["desc"] = desc
  end
  -- vim.api.nvim_buf_set_keymap(buffer, mode, keys, func, local_opts)
  vim.keymap.set(mode, keys, func, local_opts)
end

function M.get_all_lua_files(search_folder)
  local config_path = vim.fn.stdpath("config") .. "/lua/"
  local folder_path = config_path .. search_folder
  local lua_files = {}
  local handle = vim.loop.fs_scandir(folder_path)
  -- print('FILES for -> '.. folder_path)
  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end
      local path = folder_path .. "/" .. name

      if type == "file" then
        if name:match("%.lua$") then
          local relative_path = path:gsub("%.lua$", "")
          relative_path = relative_path:gsub("^" .. config_path, ""):gsub("/", ".")
          table.insert(lua_files, relative_path)
        end
      elseif type == "directory" then
        local relative_path = path:gsub("^" .. config_path, "")
        -- print('Mirando : '.. path .. '   y entrando en ' .. relative_path)
        local subfolder_lua_files = M.get_all_lua_files(relative_path)
        for _, subfile_path in ipairs(subfolder_lua_files) do
          table.insert(lua_files, subfile_path)
        end
      end
    end
  end
  return lua_files
end

function M.load_all_lua_files(folder)
  local lua_files = M.get_all_lua_files(folder)
  for _, file_path in ipairs(lua_files) do
    -- print('CARGANDO: ' .. file_path)
    require(file_path)
  end
end

-- --------------------------------------------------------------------------
-- CUSTOM WINDOW FOR LSP
-- --------------------------------------------------------------------------

-- Define a function to display LSP hover information in a custom popup window
function M.custom_lsp_hover()
  local params = vim.lsp.util.make_position_params()
  local result = vim.lsp.buf_request_sync(0, "textDocument/hover", params, 1000)

  if not result or not result[1] or not result[1].result then
    return
  end

  local contents = result[1].result.contents

  -- Calculate the width and height relative to the current window size
  local win_width = vim.fn.winwidth(0)
  local win_height = vim.fn.winheight(0)
  local width = math.min(math.floor(win_width * 0.6), 80) -- Limit width to 80 columns
  local height = math.min(math.floor(win_height * 0.3), 20) -- Limit height to 20 lines

  local row = math.floor((win_height - height) / 2)
  local col = math.floor((win_width - width) / 2)

  local border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
  }

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = border,
  }

  local bufnr, winnr
  bufnr, winnr = vim.api.nvim_open_win(0, true, opts)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)
  vim.api.nvim_win_set_option(winnr, "winhl", "Normal:Normal")

  -- Set up key mapping to close the hover popup
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })
end

-- Map a key to trigger the custom LSP hover function
-- vim.api.nvim_set_keymap('n', '<Leader>h', [[:lua custom_lsp_hover()<CR>]], { noremap = true, silent = true })

-- Use <Leader>h to display the custom LSP hover information
function M.generate_html_from_rscript(file_path)
  if not file_path then
    print("Error: File path not provided.")
    return
  end

  local output_dir = vim.fn.fnamemodify(file_path, ":p:h") -- Current file's directory
  local file_name = vim.fn.fnamemodify(file_path, ":t:r")
  local file_name_base = vim.fn.fnamemodify(file_path, ":t")

  print("KNITTING file:" .. file_name_base)
  if file_name == "" then
    print("Error: Invalid file name.")
    return
  end

  -- Check if the file extension is .R or .Rmd
  local extension = vim.fn.fnamemodify(file_path, ":e")
  if extension ~= "R" and extension ~= "Rmd" then
    print("Error: Invalid file extension. Must be .R or .Rmd.")
    return
  end

  -- Define the command to generate the .md file using knitr::spin()
  local spin_command = string.format("Rscript -e 'knitr::spin(\"%s\")'", file_path)
  -- local spin_command = string.format('Rscript -e \'knitr::spin("%s", knit = FALSE, format = "md")\'', file_name_base)
  print("SPIN --> " .. spin_command)

  -- Run the spin command to generate .md file
  os.execute(spin_command)

  -- Define the path to the generated .md file
  local md_file = output_dir .. "/" .. file_name .. ".md"

  local html_file = output_dir .. "/" .. file_name .. ".html"
  -- Define the command to render .md file to HTML using rmarkdown::render()
  local render_command = string.format(
    'Rscript -e \'rmarkdown::render("%s", output_file = "' .. html_file .. "\")'",
    md_file,
    output_dir,
    file_name
  )

  -- Run the render command to generate HTML file
  os.execute(render_command)

  print("HTML file generated successfully!" .. html_file)

  -- After rendering HTML, delete the .md file
  os.remove(md_file)
  print(".md file deleted." .. md_file)
end

return M
