return {
  "brenoprata10/nvim-highlight-colors",
  enabled = true,
  config = function()
    require("nvim-highlight-colors").setup({
      render = "background",
    })
  end,
}
