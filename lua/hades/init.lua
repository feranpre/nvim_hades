-- vim.g.maplocalleader = ","

require("hades.config.globals")
require("hades.config.lazy")

require("lazy").setup({
  { import = "hades.plugins.lsp" },
  { import = "hades.plugins.editor" },
  { import = "hades.plugins.code" },
  --   { import = "hades.plugins.notes" },
})

require("hades.config.options")
require("hades.config.keybinds")
require("hades.config.colors")
-- -- require('hades.config.autocmd')
--
-- -- require('hades.config.autocmd.r_keys')
-- -- require("hades.config.autocmd.term_keys")
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<localleader>t",
  -- ":echo 'Test mapping'<CR>",
  ":lua print('Test mapping')<CR>",
  { noremap = true, silent = true }
)
