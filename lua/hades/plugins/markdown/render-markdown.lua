return {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',
      -- "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("render-markdown").setup({
        bullet = {enabled = true},
        code = {
          enabled = true,
          sign = true,
      }

      })
    end,
}
