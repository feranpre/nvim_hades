return {
  -- for lsp features in code cells / embedded code
  "jmbuhr/otter.nvim",
  enabled = true,
  dev = false,
  dependencies = {
      "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("otter").setup({
    verbose = {
      no_code_found = true,
    },
    buffers = {
      set_filetype = true,
      write_to_disk = true,
    },
    lsp = {
      hover = {
        border = "rounded",
      },
      diagnostics = {
        virtual_text = true,
      },
    },
    filetypes = { "quarto", "markdown" },
    handle_leading_whitespace = true,
    supported_languages = { "python", "r", "bash", "lua", "julia" },
  })
  end,
}
