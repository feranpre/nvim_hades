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
      file_types = {
        "markdown",
        "quarto",
        "rmd",
      },
      anti_conceal = {
        enabled = true,
        ignore = {
          code_background = true,
        },
      },
      bullet = { enabled = true },
      code = {
        enabled = true,
        sign = true,
      },
      latex = {
        enabled = false,
      },

    })
  end,
}
