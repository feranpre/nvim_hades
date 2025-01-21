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
  },
  {
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
  },
  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    "GCBallesteros/jupytext.nvim",
    enabled = true,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
          -- extension = "md",
          -- style = "markdown",
          -- force_ft = "markdown",
        },
        r = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },

  { -- preview equations
    "jbyuki/nabla.nvim",
    enabled = true,
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },

  -- {
  --   "benlubas/molten-nvim",
  --   enabled = false,
  --   build = ":UpdateRemotePlugins",
  --   init = function()
  --     vim.g.molten_image_provider = "image.nvim"
  --     vim.g.molten_output_win_max_height = 20
  --     vim.g.molten_auto_open_output = false
  --   end,
  --   keys = {
  --     { "<leader>mi", ":MoltenInit<cr>", desc = "[m]olten [i]nit" },
  --     {
  --       "<leader>mv",
  --       ":<C-u>MoltenEvaluateVisual<cr>",
  --       mode = "v",
  --       desc = "molten eval visual",
  --     },
  --     { "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "molten re-eval cell" },
  --   },
  -- },
  --
}
