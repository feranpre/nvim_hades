return { -- Autoformat
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    require("conform").setup({
      notify_on_error = true,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "mystylua" },
        python = { "isort", "black" },
        json = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        yaml = { "yamlfix" },
        toml = { "taplo" },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
      },
      formatters = {
        mystylua = {
          command = "stylua",
          args = { "--indent-type", "Spaces", "--indent-width", "2", "-" },
        },
      },
    })
    -- Customize the "injected" formatter
    require("conform").formatters.injected = {
      -- Set the options field
      options = {
        -- Set to true to ignore errors
        ignore_errors = false,
        -- Map of treesitter language to file extension
        -- A temporary file name with this extension will be generated during formatting
        -- because some formatters care about the filename.
        lang_to_ext = {
          bash = "sh",
          c_sharp = "cs",
          elixir = "exs",
          javascript = "js",
          julia = "jl",
          latex = "tex",
          markdown = "md",
          python = "py",
          ruby = "rb",
          rust = "rs",
          teal = "tl",
          r = "r",
          typescript = "ts",
          lua = "stylua",
        },
        -- Map of treesitter language to formatters to use
        -- (defaults to the value from formatters_by_ft)
        lang_to_formatters = {},
      },
    }
  end,
}
