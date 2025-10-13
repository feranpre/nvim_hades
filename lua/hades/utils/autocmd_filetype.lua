vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "HADES file binds for r",
  pattern = { "r", "rmd", "markdown" },
  callback = function(ev)
    -- require("hades.config.keybinds.markdown").load_keys(ev)
    require("hades.config.keybinds_plugins.r").load_keys(ev)
    -- require("hades.config.keybinds_molten").load_keys(ev)
  end,
})

-- Change foldmethod to manual so it works with the folding from mkdnflow
vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  pattern = { "markdown", "rmd", "quarto" },
  callback = function(ev)
    vim.opt_local.foldmethod = "manual"
    require("hades.config.keybinds_plugins.quarto").load_keys(ev)
  end,
})
-- vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
--   desc = "HADES file binds for python, quarto and markdown",
--   pattern = { "markdown", "quarto", "python" },
--   callback = function(ev)
--     -- require("hades.config.keybinds.markdown").load_keys(ev)
--     require("hades.config.keybinds_plugins.iron").load_keys(ev)
--     -- require("hades.config.keybinds_molten").load_keys(ev)
--   end,
-- })
