vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "HADES file binds for python, quarto and markdown",
  pattern = { "markdown" },
  callback = function(ev)
    require("hades.config.keybinds_markdown").load_keys(ev)
    require("hades.config.keybinds_slime").load_keys(ev)
    require("hades.config.keybinds_molten").load_keys(ev)
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "HADES file binds for python, quarto and markdown",
  pattern = { "quarto" },
  callback = function(ev)
    require("hades.config.keybinds_quarto").load_keys(ev)
    require("hades.config.keybinds_markdown").load_keys(ev)
    require("hades.config.keybinds_slime").load_keys(ev)
    require("hades.config.keybinds_molten").load_keys(ev)
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "HADES file binds for python, quarto and markdown",
  pattern = { "rmd" },
  callback = function(ev)
    require("hades.config.keybinds_markdown").load_keys(ev)
    require("hades.config.keybinds_r").load_keys(ev)
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "HADES file binds for R",
  pattern = { "r" },
  callback = function(ev)
    require("hades.config.keybinds_r").load_keys(ev)
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "HADES file binds for python",
  pattern = { "python" },
  callback = function(ev)
    require("hades.config.keybinds_slime").load_keys(ev)
    require("hades.config.keybinds_molten").load_keys(ev)
    require("hades.config.keybinds_python").load_keys(ev)
  end,
})
