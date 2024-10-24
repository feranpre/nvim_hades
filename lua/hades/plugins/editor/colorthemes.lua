return {
  { "shaunsingh/nord.nvim", enabled = true, lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", enabled = true, lazy = false, priority = 1000 },
  { "EdenEast/nightfox.nvim", enabled = true, lazy = false, priority = 1000 },
  { "navarasu/onedark.nvim", enabled = true, lazy = false, priority = 1000 },
  {
    "catppuccin/nvim",
    enabled = true,
    name = "catppuccin",
    lazy = true, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- vim.cmd.colorscheme("catppuccin-mocha")
      -- vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   enabled = true,
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- vim.cmd.colorscheme("onedark")
  --     -- vim.cmd.colorscheme("onelight")
  --     -- vim.cmd.colorscheme("onedark_vivid")
  --     -- vim.cmd.colorscheme("onedark_dark")
  --   end,
  -- },

  {
    "Mofiqul/dracula.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          -- green = "#50fa7b",
          green = "#BD93F9",
          -- purple = "#BD93F9",
          purple = "#50fa7b",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
          white = "#ABB2BF",
          black = "#191A21",
        },
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = false, -- default false
        -- use transparent background
        transparent_bg = true, -- default false
        -- set custom lualine background color
        lualine_bg_color = "#44475a", -- default nil
        -- set italic comment
        italic_comment = true, -- default false
        -- overrides the default highlights with table see `:h synIDattr`
        overrides = {},
        -- You can use overrides as table like this
        -- overrides = {
        --   NonText = { fg = "white" }, -- set NonText fg to white
        --   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
        --   Nothing = {} -- clear highlight of Nothing
        -- },
        -- Or you can also use it like a function to get color from theme
        -- overrides = function (colors)
        --   return {
        --     NonText = { fg = colors.white }, -- set NonText fg to white of theme
        --   }
        -- end,
      })
    end,
  },
  {
    "neanias/everforest-nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
  },
  {
    "loctvl842/monokai-pro.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai-pro").setup()
      -- vim.cmd.colorscheme("monokai-pro")
    end,
  },

  -- color html colors
  {
    "NvChad/nvim-colorizer.lua",
    enabled = true,
    opts = {
      filetypes = { "*" },
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = true, -- 'Name' codes like Blue or blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      AARRGGBB = false, -- 0xAARRGGBB hex codes
      rgb_fn = false, -- CSS rgb() and rgba() functions
      hsl_fn = false, -- CSS hsl() and hsla() functions
      css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = "background", -- Set the display mode.
      -- Available methods are false / true / 'normal' / 'lsp' / 'both'
      -- True is same as normal
      tailwind = false, -- Enable tailwind colors
      -- parsers can contain values used in |user_default_options|
      sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
      virtualtext = "■",
      -- update color values even if buffer is not focused
      -- example use: cmp_menu, cmp_docs
      always_update = false,
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
    },
  },
}
