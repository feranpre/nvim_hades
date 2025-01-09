return {
  { 'echasnovski/mini.statusline', 
    version = '*',
    enabled = true,
    config = function()
      require("mini.statusline").setup({
        use_icons = true,
      })
    end
  },
}
