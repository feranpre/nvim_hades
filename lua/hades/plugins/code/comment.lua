return {
  "numToStr/Comment.nvim",
  enabled = true,
  opts = {
    -- add any options here
  },
  config = function()
    require("Comment").setup()
  end,
  lazy = false,
}
