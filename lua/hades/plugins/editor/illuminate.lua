return {
  "RRethy/vim-illuminate",
  enabled = true,
  lazy = false,
  config = function()
    require("illuminate").configure({})
  end,
}
