return {
  "OXY2DEV/markview.nvim",
  enabled = true,
  lazy = false, -- Recommended
  -- branch = "dev",
  -- priority = 500,
  -- ft = "markdown" -- If you decide to lazy-load
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ---
  --- Configuration table for `markview.nvim`.
  ---@class mkv.config
  ---@field experimental config.experimental | fun(): config.experimental
  ---@field highlight_groups { [string]: config.hl } | fun(): { [string]: config.hl }
  ---@field html config.html | fun(): config.html
  ---@field latex config.latex | fun(): config.latex
  ---@field markdown config.markdown | fun(): config.markdown
  ---@field markdown_inline config.markdown_inline | fun(): config.markdown_inline
  ---@field preview config.preview | fun(): config.preview
  ---@field renderers config.renderer[] | fun(): config.renderer[]
  ---@field typst config.typst | fun(): config.typst
  ---@field yaml config.yaml | fun(): config.yaml

  opts = {
    preview = {
      enable = true,
      modes = { "n", "i", "no", "c" },
      hybrid_modes = { "i" },
      filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante", "quarto" },
      buf_ignore = {},
      -- This is nice to have
      callbacks = {},
    },
    markdown = {
      enable = true,
      headings = {},
      -- code_blocks = {
      --   enable = true,
      --
      --   style = "language",
      --   border_hl = "dark",
      --
      --   position = "overlay",
      --
      --   min_width = 60,
      --   pad_amount = 3,
      --
      --   language_direction = "right",
      --
      --   sign = true,
      --   sign_hl = nil,
      -- },
      --
      block_quote = {
        enable = true,
        default = {},
        callouts = {},
      },

      horizontal_rule = {},

      hyperlink = {},
      image = {},

      table = {
        table_hls = { "rainbow1" },
        use_virt_lines = false,
      },
      list_item = {
        marker_plus = {
          add_padding = false,
          marker = "•",
          marker_hl = "rainbow2",
        },
        marker_minus = {
          add_padding = false,
          marker = "•",
          marker_hl = "rainbow2",
        },
        marker_star = {
          add_padding = false,

          marker = "•",
          marker_hl = "rainbow2",
        },
      },
      checkbox = {},
    },

    html = {
      enable = true,

      tags = {},
    },
    markdown_inline = {
      enable = true,
      entities = {},

      inline_codes = {
        enable = true,
      },

      hyperlinks = {
        enable = true,
      },

      images = {
        enable = true,
      },
    },
  },
}
