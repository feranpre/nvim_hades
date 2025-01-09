return {
  { "shaunsingh/nord.nvim", enabled = false, lazy = false, priority = 1000, config = function() vim.cmd.colorscheme "nord" end },
  { "folke/tokyonight.nvim", enabled = true, lazy = false, priority = 1000, config = function() vim.cmd.colorscheme "tokyonight-storm" end },
}
 
