return {
  {
    "saghen/blink.compat",
    enabled = true,
    lazy = true,
    opts = {
      impersonate_nvim_cmp = true,
      debug = true,
    },
    config = function()
      require("blink.compat").setup({})
    end,
  },
}
