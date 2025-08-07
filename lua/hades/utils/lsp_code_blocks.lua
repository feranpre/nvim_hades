local function get_codeblock_language_at_cursor()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()

  while node do
    if node:type() == "fenced_code_block" then
      local info_node = node:child(0)
      if info_node then
        local info_text = vim.treesitter.get_node_text(info_node, 0)
        local lang = info_text:match("^%s*([%w_+-]+)")
        return lang or "markdown"
      end
    end
    node = node:parent()
  end
  return "markdown"
end



local function enable_lsp_in_code_block()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()

  while node do
    if node:type() == "fenced_code_block" then
      local lang_node = node:child(0) -- Extract the language from the code block
      if lang_node then
        local lang = vim.treesitter.get_node_text(lang_node, 0) -- Get the language
        vim.bo.filetype = lang -- Change filetype to match code block language
        return
      end
    end
    node = node:parent()
  end
  vim.bo.filetype = "markdown" -- Reset to markdown outside code blocks
end

-- vim.api.nvim_create_autocmd("CursorMoved", {
--   pattern = "*.md",
--   callback = enable_lsp_in_code_block,
-- })
