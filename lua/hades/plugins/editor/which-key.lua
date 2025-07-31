return {
  "folke/which-key.nvim",
  enabled = true,
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 1300
    require("which-key").setup({
      triggers = {
                  { "<auto>", mode = "nixsotc" },
        { "<leader>",      mode = { "n", "v" } },
        { "<localleader>", mode = { "n", "v" } },
        { "g",             mode = { "n", "v" } },
        { "z",             mode = { "n", "v" } },
      },
    })
  end,
}
