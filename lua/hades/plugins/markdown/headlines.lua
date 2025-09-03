return {
  "lukas-reineke/headlines.nvim",
  enabled = false,
  -- cond = has_ui,
  dependencies = "nvim-treesitter/nvim-treesitter",
  ft = "markdown",
  config = function()
    require("headlines").setup()
  end
  
}
