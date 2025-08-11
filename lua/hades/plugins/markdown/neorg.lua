return {
  "nvim-neorg/neorg",
  dependencies = {
    -- image-nvim configured in repl/image-nvim
  },
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = function()
    local opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            conceal = true,
            icon_preset = "diamond",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/git/markdown_vault/nvim/neorg/",
            },
            index = "index.norg",
          },
        },
        ["core.latex.renderer"] = {
          config = {
            conceal = true,
            debounce_ms = 200, -- don't render after 200ms of editing
            dpi = 350,
            min_length = 1, -- I want greek letters rendered
            render_on_enter = true,
          },
        },
        ["core.autocommands"] = {},
        ["core.highlights"] = {},
        ["core.neorgcmd"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.integrations.image"] = {},
      },
    }
    require("neorg").setup(opts)
  end,
}
