require("hades.config.globals")
require("hades.config.lazy")

require("lazy").setup({
  { import = "hades.plugins.lsp" },
  { import = "hades.plugins.editor" },
  { import = "hades.plugins.code" },
})

require("hades.config.options")
require("hades.config.keybinds")
require("hades.config.colors")
-- require("hades.config.autocmd")

-- require("hades.config.autocmd.r_keys")
require("hades.config.autocmd.term_keys")
require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/nvim/lua/hades/hades_snippets" } })
