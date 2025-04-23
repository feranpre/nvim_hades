return {

  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    "quarto-dev/quarto-nvim",
    enabled = true,
    ft = { "quarto" },
    dev = false,
    opts = {},
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua and
      -- added as a nvim-cmp source in lua/plugins/completion.lua
      "jmbuhr/otter.nvim",
    },
    config = function()
      require("quarto").setup {
        lspFeatures = {
          languages = { "python", "r", "bash", "lua" },
          chunks = "curly", -- needed for {{python}} chunks
        },
      }
    end,
  },
}
