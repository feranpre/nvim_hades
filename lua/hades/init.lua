--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("hades.lazy")
require("lazy").setup({
  -- { import = "hades.mini" },
  { import = "hades.plugins.lsp" },
  { import = "hades.plugins.code" },
  { import = "hades.plugins.editor" },
})

require("hades.config.options")
require("hades.config.keybinds")
require("hades.config.colorscheme")

require("hades.autocmd.lsp_autocmd")
require("hades.autocmd.spell_autocmd")
-- require("hades.autocmd.caronte_debug")
