--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","
Hades = require("hades.config.hades")

require("hades.lazy")
require("lazy").setup({
  { import = "hades.plugins.lsp" },
  { import = "hades.plugins.code" },
  { import = "hades.plugins.editor" },
  { import = "hades.plugins.colorschemes" },
})

DEBUG = false
IsModuleAvailable = require("hades.misc.utils").isModuleAvailable

require("hades.config.options")
require("hades.config.colorscheme")
require("hades.config.keybinds")
require("hades.config.keybinds_plugins")

require("hades.autocmd.format_on_save")
-- require("hades.autocmd.spell_autocmd")
-- require("hades.autocmd.caronte_debug")
