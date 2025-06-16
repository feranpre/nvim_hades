-- TODO: sadfasdf

-- Remap space as leader key
vim.g.mapleader = " "

-- Remap localleader to ,
vim.g.maplocalleader = ","

-- get Hades basic config
Hades = require("hades.config.hades")

require("hades.lazy")
require("lazy").setup({
  { import = "hades.plugins.lsp" },
  { import = "hades.plugins.code" },
  { import = "hades.plugins.editor" },
  { import = "hades.plugins.colorschemes" },
  { import = "hades.plugins.markdown" },
  { import = "hades.plugins.repl" },
})

DEBUG = false
-- Molten_or_Slime = "slime"
IsModuleAvailable = require("hades.utils.keys").isModuleAvailable

require("hades.config.options")
require("hades.utils.utils").load_colorscheme(Hades)
require("hades.utils.utils").load_colorscheme(Hades)

-- require("hades.utils.utils").load_color_highlights(Hades)

-- require("hades.config.colorscheme")
require("hades.config.keybinds")
require("hades.config.keybinds_plugins")

-- require("hades.config.keybinds_molten")

-- require("hades.autocmd.format_on_save")
require("hades.autocmd.keybinds_by_filetype") -- load keybinds for specific filetypes
-- require("hades.autocmd.lsp_in_markdown_codeblocks") -- lsp support inside code-blocks

require("hades.utils.python_commands")
-- require("hades.custom_commands")
-- require("hades.autocmd.spell_autocmd")
-- require("hades.autocmd.caronte_debug")
--

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto" },
  callback = function()
    vim.bo.textwidth = 80
    vim.opt_local.formatoptions:remove("l") -- remove the no-break-in-insert flag
  end,
})
