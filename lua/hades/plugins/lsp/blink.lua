return {
  {
    "saghen/blink.cmp",
    version = "*",
    -- dependencies = "rafamadriz/friendly-snippets",
    -- dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    lazy = true,

    opts = {
      keymap = { preset = "default" },
      -- snippets = { preset = "luasnip" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "cmp_r", "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          cmp_r = {
            name = "cmp_r",
            module = "blink.compat.source",
            opts = {
              filetypes = { "r", "rmd", "quarto" },
            },
          },
        },
      },
      signature = {
        enabled = true,
      },
      completion = {
        menu = {
          border = "single",
        },
        documentation = {
          auto_show = true,
          window = {
            border = "single",
          },
        },
        -- Displays a preview of the selected item on the current line
        ghost_text = {
          enabled = false,
        },
      },
    }, -- opts
    opts_extend = {
      "sources.default",
      "sources.compat",
      "sources.completion.enabled_providers",
    },
  },
}
