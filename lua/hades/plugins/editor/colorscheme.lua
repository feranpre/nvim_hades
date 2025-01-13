-- color = "#FF0000"

return {
  {
    "shaunsingh/nord.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    -- config = function()
    --   -- vim.cmd.colorscheme("nord")
    -- end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    -- config = function()
    --   -- vim.cmd.colorscheme("tokyonight-storm")
    -- end,
  },
  {
    "embark-theme/vim",
    name = "embark-theme",
    enabled = true,
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
      -- flavour = "frape"
    end,
  },
}
