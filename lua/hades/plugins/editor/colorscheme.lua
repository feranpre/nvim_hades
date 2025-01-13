-- color = "#FF0000"

return {
  {
    "shaunsingh/nord.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    -- config = function()
    --   -- vim.cmd.colorscheme("nord")
    -- end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    -- config = function()
    --   -- vim.cmd.colorscheme("tokyonight-storm")
    -- end,
  },
  {
    "embark-theme/vim",
    name = "embark-theme",
    enabled = false,
    lazy = false,
    priority = 1000,
    -- config = function()
    --   -- vim.cmd.colorscheme("embark")
    -- end,
  },
  {
    "catppuccin/nvim",
    enabled = true,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        integrations = {
          markdown = false,
        },
      })
      -- flavour = "frappe"
    end,
  },
}
