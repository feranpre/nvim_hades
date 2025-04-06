return {
  "echasnovski/mini.tabline",
  version = "*",
  enabled = true,

  config = function()
    require("mini.tabline").setup({
    show_icons = true,
      set_vim_settings = true,
    })
  end
}
