vim.lsp.enable({
  "lua_ls",
  "r_languageserver",
  "pyright",
  "markdown",
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
--       vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--       -- require("hades.config.keybinds_plugins.lsp").load_keys(ev)
--     end
--   end,
-- })
--

local signs = Hades.icons.diagnostics

for type, icon in pairs(signs) do
  local name = "DiagnosticSign" .. type
  vim.api.nvim_set_hl(0, name, { default = true, link = "Diagnostic" .. type })
  -- Use the new API if available, else fallback
  if vim.api.nvim_set_sign then
    vim.api.nvim_set_sign(name, { text = icon, texthl = name, numhl = "" })
  else
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
end


-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,  -- no inline diagnostics
  signs = true,          -- keep signs in the gutter
  underline = true,      -- underline problematic code
  update_in_insert = false, -- don’t update while typing
  severity_sort = true,  -- sort diagnostics by severity
})

-- Show diagnostics in a floating window on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      border = "rounded",
      scope = "cursor",
    })
  end,
})
