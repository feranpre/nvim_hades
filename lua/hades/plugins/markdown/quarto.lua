return {
  -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
  -- for complete functionality (language features)
  "quarto-dev/quarto-nvim",
  enabled = true,
  ft = { "quarto", "markdown" },
  dev = false,
  opts = {},
  dependencies = {
    -- for language features in code cells
    -- configured in lua/plugins/lsp.lua and
    -- added as a nvim-cmp source in lua/plugins/completion.lua
    "jmbuhr/otter.nvim",
  },
  config = function()
    require("quarto").setup({
      lspFeatures = {
        languages = { "python", "r", "bash", "lua" },
        chunks = "curly", -- needed for {{python}} chunks
      },
      codeRunner = {
        enabled = true,
        -- default_method = "slime", -- "molten", "slime", "iron" or <function>
        default_method = "iron", -- "molten", "slime", "iron" or <function>
        ft_runners = {
          python = "iron",
          r = "r-nvim",

        }, -- filetype to runner, ie. `{ python = "molten" }`.
        -- Takes precedence over `default_method`
        never_run = { "yaml" }, -- filetypes which are never sent to a code runner
      },
    })
  end,
}
