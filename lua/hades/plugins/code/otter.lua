return {
  -- for lsp features in code cells / embedded code
  "jmbuhr/otter.nvim",
  enabled = true,
  dev = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  opts = {
    verbose = {
      no_code_found = false,
    },
  },
}
