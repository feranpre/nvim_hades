return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  enabled = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon").setup()
    require("hades.config.keybinds_plugins.harpoon")
  end,
}
