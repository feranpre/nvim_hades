
if DEBUG then
  print("   -- loaded keybinds for - lsp")
end

local M = {}

function M.load_keys(ev)

  local keymap = require("hades.utils.keys").keymap
  local keymap_buffer = require("hades.utils.keys").keymap_buffer
  local key_or_clue = require("hades.utils.keys").key_or_clue

  local opts = { noremap = true, silent = true, desc = nil }

  keymap_buffer(ev.buf, "i", "<C-Space>", vim.lsp.completion.get, opts, "lsp suggestions")
  keymap_buffer(ev.buf, "n", "<localleader>ca", vim.lsp.buf.code_action, opts, "[c]ode [a]ction")

  -- REFERENCES
  keymap_buffer(0, "n", "grr", "<cmd>lua vim.lsp.buf.references()<CR>", opts, "LSP -> show references") -- show lsp implementations

  -- rename
  keymap_buffer(0, "n", "grn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "LSP -> rename in scope") -- show lsp implementations
  keymap_buffer(0, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename() <CR>", opts, "[l]sp [r]ename in scope") -- smart rename


  -- diagnostics
  keymap_buffer(
    0,
    "n",
    "<leader>ld",
    "<cmd>lua vim.diagnostic.open_float() <CR>",
    opts,
    "[l]sp [d]iagnostics (line)"
  )


  keymap("v", "<leader>lf", vim.lsp.buf.format, opts, "[l]sp [f]ormat visual selection")

  -- move through diagnostic
  keymap_buffer(0, "n", "<M-j>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts, "lsp - prev diagnostic")
  keymap_buffer(0, "n", "<M-k>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts, "lsp - next diagnostic")

  keymap_buffer(0, "n", "<leader>[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts, "lsp - prev diagnostic")
  keymap_buffer(0, "n", "<leader>]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts, "lsp - next diagnostic")

  -- actions
  keymap_buffer(0, {"n", "v"}, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "[l]sp code [a]ctions") -- show lsp implementations

  -- definitions and lsp_implementations
  keymap_buffer(0, "n", "gD", "<cmd>lua vim.lsp.buf.declaration() <CR>", opts, "LSP -> go to definition")
  keymap_buffer(0, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts, "LSP -> show lsp definitions")
  keymap_buffer(0, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts, "LSP -> show implementations") -- show lsp implementations
  keymap_buffer(0, "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts, "LSP -> show type definitions") -- show lsp implementations

  -- help
  keymap_buffer(0, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts, "LSP -> Doc for string under cursor")

  -- restgart
  keymap_buffer(0, "n", "<leader>ls", "<cmd>LspRestart<CR>", opts, "[l]sp [s]tart/restart LSP")


  -- Telescope
  local telescope_ok, _ = pcall(function()
    require("telescope")
  end)

  if telescope_ok then
    keymap_buffer(0, "n", "gR", "<cmd>Telescope lsp_references<CR>", opts, "LSP -> show definition references")
    keymap_buffer(
      0,
      "n",
      "<leader>lD",
      "<cmd>Telescope diagnostics bufnr=0<CR>",
      opts,
      "[l]sp [D]iagnostics (buffer)"
    ) -- show lsp implementations


  end
end

return M
