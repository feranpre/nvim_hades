-- TODO: sadfasdf

-- Remap space as leader key
vim.g.mapleader = " "

-- Remap localleader to ,
vim.g.maplocalleader = ","

vim.g.kitty_keyboard = true

-- get Hades basic config
Hades = require("hades.config.hades")
require("hades.config.options")

IsModuleAvailable = require("hades.utils.module_available").isModuleAvailable

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

require("hades.config.keybinds")

require("hades.config.lsp")

vim.cmd.colorscheme(Hades.colorscheme)

require("hades.autocmd.filetype")
require("hades.autocmd.on_save")
require("hades.autocmd.commands")

--require("hades.plugins.keybinds")
-- require("hades.utils.utils").load_colorscheme(Hades)

-- require("hades.utils.utils").load_color_highlights(Hades)

-- require("hades.config.colorscheme")
-- require("hades.config.keybinds_plugins")

-- require("hades.config.keybinds_molten")

-- require("hades.autocmd.format_on_save")
-- require("hades.autocmd.keybinds_by_filetype") -- load keybinds for specific filetypes
-- require("hades.autocmd.lsp_in_markdown_codeblocks") -- lsp support inside code-blocks

-- require("hades.utils.python_commands")
-- require("hades.custom_commands")
-- require("hades.autocmd.spell_autocmd")
-- require("hades.autocmd.caronte_debug")
