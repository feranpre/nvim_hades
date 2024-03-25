local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------- CONFIG -----------------
local opts = {
  defaults = {
    lazy = true,
  },
  install = {
    missing = true,
    colorscheme = { "onedark" },
  },
  change_detection = {
    notify = true,
  },
  rtp = {
    disabled_plugins = {
      "netrw", -- removed by nvim-tree
      "netwrPlugin", -- removed by nvim-tree
      "gzip",
      "matchit",
      "matchparen",
      "tarPlugin",
      "tohtml",
      "zipPlugin",
    },
  },
}

-- lazy setup (load of plugins is done in ~/.config/lua/hades/init.lua)
-- require("lazy").setup({
--  { import = "hades.plugins.core" },
--  { import = "hades.plugins.editor" },
--}, opts)
