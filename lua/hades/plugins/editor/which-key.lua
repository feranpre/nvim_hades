return {
  "folke/which-key.nvim",
  enabled = true,

  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup({
      triggers = {
        { "<leader>",      mode = { "n", "v" } },
        { "<localleader>", mode = { "n", "v" } },
        { "g",             mode = { "n", "v" } },
        { "z",             mode = { "n", "v" } },
      },
    })
  end,
}
