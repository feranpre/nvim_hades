return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "onsails/lspkind-nvim" },
    { "f3fora/cmp-spell" },
    { "R-nvim/cmp-r" },
  },
  -- event = 'InsertEnter',
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/nvim/lua/hades/hades_snippets" } })
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },

      -- mapping = cmp.mapping.preset.insert({
      --   ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      --   ['<C-f>'] = cmp.mapping.scroll_docs(4),
      --   ['<C-Space>'] = cmp.mapping.complete(),
      --   ['<C-e>'] = cmp.mapping.abort(),
      --   ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      -- }),
      sources = cmp.config.sources({
        { name = "luasnip", keyword_length = 2, max_item_count = 3 },
        -- { name = 'otter' }, -- for code chunks in quarto
        { name = "path" },
        { name = "nvim_lsp", max_item_count = 5 },
        { name = "cmp_r" },
        { name = "pandoc_references" },
        { name = "buffer", keyword_length = 5, max_item_count = 3 },
        { name = "spell" },
        { name = "treesitter", keyword_length = 5, max_item_count = 3 },
        { name = "calc" },
        { name = "latex_symbols" },
        { name = "emoji" },
      }, {
        { name = "buffer" },
      }),

      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = function(entry, item)
          local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
          item = require("lspkind").cmp_format({
            mode = "symbol",
            menu = {
              luasnip = "[snip]",
              -- otter = '[🦦]',
              nvim_lsp = "[LSP]",
              cmp_r = "[R]",
              buffer = "[buf]",
              path = "[path]",
              spell = "[spell]",
              pandoc_references = "[ref]",
              tags = "[tag]",
              treesitter = "[TS]",
              calc = "[calc]",
              latex_symbols = "[tex]",
              emoji = "[emoji]",
            },
          })(entry, item)
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          return item
        end,
        -- format = lspkind.cmp_format({
        --   mode = "symbol",
        --   menu = {
        --     luasnip = "[snip]",
        --     -- otter = '[🦦]',
        --     nvim_lsp = "[LSP]",
        --     cmp_r = "[R]",
        --     buffer = "[buf]",
        --     path = "[path]",
        --     spell = "[spell]",
        --     pandoc_references = "[ref]",
        --     tags = "[tag]",
        --     treesitter = "[TS]",
        --     calc = "[calc]",
        --     latex_symbols = "[tex]",
        --     emoji = "[emoji]",
        --   },
        -- }),
      },
    })
    --
    -- Set configuration for specific filetype.
    -- cmp.setup.filetype('gitcommit', {
    --   sources = cmp.config.sources({
    --     { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    --   }, {
    --     { name = 'buffer' },
    --   }),
    -- })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
    -- cmp.setup.filetype('r', {
    --   sources = cmp.config.sources({
    --     { name = 'luasnip', keyword_length = 3, max_item_count = 3 },
    --     { name = 'cmp_r' },
    --   }),
    -- })
    -- require('luasnip.loaders.from_vscode').lazy_load()
    -- require('luasnip.loaders.from_vscode').lazy_load({ paths = { './lua/hades/my_snippets' } })
  end,
}
