require("caronte.config.globals")
require("caronte.config.lazy")

require("lazy").setup({
  { import = "caronte.plugins.lsp" },
  { import = "caronte.plugins.editor" },
  { import = "caronte.plugins.code" },
})

require("caronte.config.options")
require("caronte.config.keybinds")
require("caronte.config.colors")
-- require("caronte.config.autocmd")

-- require("caronte.config.autocmd.r_keys")
require("caronte.config.autocmd.term_keys")
