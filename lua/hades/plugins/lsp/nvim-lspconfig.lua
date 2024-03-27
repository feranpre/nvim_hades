return {
  "neovim/nvim-lspconfig",

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { -- nice loading notifications
      -- PERF: but can slow down startup
      "j-hui/fidget.nvim",
      enabled = false,
      opts = {},
    },
    { "folke/neodev.nvim", opts = {}, enabled = true },
    { "folke/neoconf.nvim", opts = {}, enabled = false },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_installation = true,
    })
    require("mason-tool-installer").setup({
      ensure_installed = {
        "black",
        "stylua",
        "shfmt",
        "isort",
      },
    })

    local lsp_flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    }

    -- local cmp_nvim_lsp = require('cmp_nvim_lsp')
    -- local capabilities = cmp_nvim_lsp.default_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- ------------------------------------------------------------------------------------
    -- lua
    -- ------------------------------------------------------------------------------------
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      flags = lsp_flags,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize 'vim' global
          diagnostics = {
            globals = { "vim", "quarto", "pandoc", "io", "string", "print", "require", "table" },
            disable = { "trailing-space" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
          telemetry = {
            enable = false,
          },
        },
      },
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
