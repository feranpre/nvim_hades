return {
  "windwp/nvim-autopairs",
  enabled = true,
  event = "InsertEnter",
  opts = function()
    require("nvim-autopairs").setup({})
    require("nvim-autopairs").remove_rule("`")
  end,
}
