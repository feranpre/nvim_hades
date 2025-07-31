vim.g.mapleader = " "
vim.g.maplocalleader = ","

DEBUG = true

require("hades.config.options") -- after colorscheme loading but before other plugins that may change something

-- Load lazy and colorscheme
require("hades.lazy")
require("lazy").setup({
  spec = {
    { import = "hades.plugins.lsp" },
    { import = "hades.plugins.code" },
    { import = "hades.plugins.editor" },
    { import = "hades.plugins.colorschemes" },
    { import = "hades.plugins.markdown" },
    { import = "hades.plugins.repl" },
  },
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true },
})



-- require("hades.config.options")
-- Molten_or_Slime = "slime"
-- IsModuleAvailable = require("hades.utils.keys").isModuleAvailable

require("hades.config.keybinds")
require("hades.config.keybinds_plugins")
require("hades.config.keybinds_repl")


-- require("hades.utils.utils").load_colorscheme(Hades)

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown", "quarto" },
--   callback = function()
--     vim.bo.textwidth = 80
--     vim.opt_local.formatoptions:remove("l") -- remove the no-break-in-insert flag
--   end,
-- })
