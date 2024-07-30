return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  enabled = true,
  config = function()
    require("neo-tree").setup({
      filesystem = {
        hijack_netrw_behavior = "open_default",
      },
      close_if_last_window = true,
    })
  end,
}
