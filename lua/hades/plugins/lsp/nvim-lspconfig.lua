-- UPDATE 2025/01/11
--
-- Eliminando CMP y cambiandolo por blink
--
return {
  "neovim/nvim-lspconfig",

  dependencies = {
    -- "hrsh7th/cmp-nvim-lsp",
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },         -- configuration of mason and lsp
    { "WhoIsSethDaniel/mason-tool-installer.nvim" }, -- install 3rd party extensions in the system
    { "folke/lazydev.nvim",                       opts = {}, enabled = true },
  },
  config = function()
    local lspconfig = require("lspconfig")

    -- local util = require("lspconfig.util")

    --
    -- -- FLAGS
    --
    local lsp_flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    }

    --
    -- -- BLINK
    --
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    --
    -- -- SYMBOLS
    --
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- -- ------------------------------------------------------------------------------------
    -- -- lua
    -- -- ------------------------------------------------------------------------------------
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      flags = lsp_flags,
      -- settings = { -- custom settings for lua
      --   Lua = {
      --     -- make the language server recognize 'vim' global
      --     diagnostics = {
      --       globals = { "vim", "quarto", "pandoc", "io", "string", "print", "require", "table" },
      --       disable = { "trailing-space" },
      --     },
      --     workspace = {
      --       -- make language server aware of runtime files
      --       library = {
      --         [vim.fn.expand("$VIMRUNTIME/lua")] = true,
      --         [vim.fn.stdpath("config") .. "/lua"] = true,
      --       },
      --     },
      --     telemetry = {
      --       enable = false,
      --     },
      --   },
      -- },
    })

    -- ------------------------------------------------------------------------------------
    -- R
    -- ------------------------------------------------------------------------------------
    lspconfig.r_language_server.setup({
      capabilities = capabilities,
      flags = lsp_flags,
      settings = {
        r = {
          lsp = {
            rich_documentation = false,
            -- allow_right_assign = true,
            -- T_and_F_symbol_linter = false,
          },
          diagnostics = true,
          -- disabled = { "commented_code_linter" },
          -- disabled = { "assignment_linter", "commentedCode" },
          -- },
          -- assignment_linter = NULL,
        },
      },
    })
  end,
}
