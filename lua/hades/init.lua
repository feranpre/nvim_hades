--Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require("hades.lazy")
require("lazy").setup({
  { import = "hades.mini" },
  { import = "hades.plugins.editor" },
  { import = "hades.plugins.code" },
  { import = "hades.plugins.lsp" },
})


require("hades.config.options")
require("hades.config.keybinds")

require("hades.misc.lsp_autocmd")
