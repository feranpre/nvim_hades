return {
  "R-nvim/cmp-r",
  enabled = true,
  lazy = false,
  config = function()
    require("cmp_r").setup()
  end,
}
