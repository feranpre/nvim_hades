-- get Hades basic config
Hades = require("hades.config.hades")
DEBUG = false

vim.g.mapleader = Hades.leader
vim.g.maplocalleader = Hades.localleader

IsModuleAvailable = require("hades.utils.keys").isModuleAvailable

require("hades.lazy")

require("hades.config.options")
require("hades.config.keybinds")

require("lazy").setup({
  -- { import = "hades.plugins.lsp" },
  { import = "hades.plugins.code" },
  { import = "hades.plugins.editor" },
  { import = "hades.plugins.colorschemes" },
  { import = "hades.plugins.markdown" },
  { import = "hades.plugins.repl" },
})

require("hades.config.keybinds_plugins")
require("hades.config.lsp")
require("hades.utils.autocmd_filetype")
require("hades.utils.lsp_code_blocks")

vim.cmd.colorscheme(Hades.colorscheme)

-- vim.g.R_filetypes = { "r", "rmd", "quarto", "rnoweb", "markdown", "rhelp" }
vim.g.R_filetypes = { "r", "rmd", "rnoweb", "quarto", "rhelp", "markdown" }

for key, value in pairs(vim.g.R_filetypes) do
  print(key, value)
end
