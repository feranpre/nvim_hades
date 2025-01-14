vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  desc = "markdown files",
  -- pattern = { "r", "quarto" },
  pattern = { "markdown" },
  callback = function(ev)
    local opts = { noremap = true, silent = true, desc = nil }
    local keymap = require("hades.misc.utils").keymap
    local pandoc_to_revealjs = require("hades.misc.pandoc_utils").pandoc_to_revealjs
    local keymap_buffer = require("hades.misc.utils").keymap_buffer
    local isModuleAvailable = require("hades.misc.utils").isModuleAvailable

    keymap("n", "<localleader>pr", pandoc_to_revealjs, opts, "[p]andoc render [r]evealjs presentation")
  end,
})
