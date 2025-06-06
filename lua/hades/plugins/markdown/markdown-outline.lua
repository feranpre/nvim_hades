-- https://github.com/hedyhli/outline.nvim
-- A sidebar with a tree-like outline of symbols from your code, powered by LSP
--
-- There are also some related plugins like `aerial.nvim` found below
-- https://github.com/hedyhli/outline.nvim?tab=readme-ov-file#related-plugins
--
return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    -- { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  config = function()
    require("outline").setup({
    symbol_folding = {
      -- Unfold entire symbol tree by default with false, otherwise enter a
      -- number starting from 1
      autofold_depth = false,
      -- autofold_depth = 1,
    },
    outline_window = {
      position = "left",
    },
    providers = {
        priority = { "markdown", "lsp", "coc", "norg" },
        markdown = {
          filetypes = {"markdown", "quarto"},

        },
    },
  })
  end,
}

