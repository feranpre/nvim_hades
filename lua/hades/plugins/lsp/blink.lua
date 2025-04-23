return {
  {
    "saghen/blink.cmp",
    dependencies = { "ribru17/blink-cmp-spell" },
    version = "*",
    -- dependencies = "rafamadriz/friendly-snippets",
    -- dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    lazy = true,
    enabled = true,

    opts = {
      keymap = { preset = "default" },
      snippets = { preset = "luasnip" },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "snippets", "cmp_r", "lazydev", "lsp", "otter", "spell", "path", "buffer" },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          cmp_r = {
            name = "cmp_r",
            module = "blink.compat.source",
            opts = {
              filetypes = {"r", "rmd"},
            },
          },
          otter = {
            name = "otter",
            module = "blink.compat.source",
            opts = {
              filetypes = { "quarto" },
            },
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            opts = {
              -- EXAMPLE: Only enable source in `@spell` captures, and disable it
              -- in `@nospell` captures.
              enable_in_context = function()
                local curpos = vim.api.nvim_win_get_cursor(0)
                local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                local in_spell_capture = false
                for _, cap in ipairs(captures) do
                  if cap.capture == "spell" then
                    in_spell_capture = true
                  elseif cap.capture == "nospell" then
                    return false
                  end
                end
                return in_spell_capture
              end,
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
          draw = {
            treesitter = {"lsp"},
            components = {
              kind_icon = {
                text = function(ctx)
                  -- local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  local kind_icon, _, _ = Hades.icons.kinds[ctx.kind]
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                -- highlight = function(ctx)
                --   local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                --   return hl
                -- end,
              },
            },
          },
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
      fuzzy = {
        implementation = "rust",
        prebuilt_binaries = {
          download = true,
          ignore_version_mismatch = false,
          force_version = nil,
          force_system_triple = nil,
        },
        sorts = {
          function(a, b)
            local sort = require("blink.cmp.fuzzy.sort")
            if a.source_id == "spell" and b.source_id == "spell" then
              return sort.label(a, b)
            end
          end,
          -- This is the normal default order, which we fall back to
          "score",
          "kind",
          "label",
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
