return {
  "folke/snacks.nvim",
  
  priority = 1000,
  lazy = false,
  config = function()
    local opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = table.concat({
          " ██░ ██  ▄▄▄      ▓█████▄ ▓█████   ██████ ",
          "▓██░ ██▒▒████▄    ▒██▀ ██▌▓█   ▀ ▒██    ▒ ",
          "▒██▀▀██░▒██  ▀█▄  ░██   █▌▒███   ░ ▓██▄   ",
          "░▓█ ░██ ░██▄▄▄▄██ ░▓█▄   ▌▒▓█  ▄   ▒   ██▒",
          "░▓█▒░██▓ ▓█   ▓██▒░▒████▓ ░▒████▒▒██████▒▒",
          " ▒ ░░▒░▒ ▒▒   ▓▒█░ ▒▒▓  ▒ ░░ ▒░ ░▒ ▒▓▒ ▒ ░",
          " ▒ ░▒░ ░  ▒   ▒▒ ░ ░ ▒  ▒  ░ ░  ░░ ░▒  ░ ░",
          " ░  ░░ ░  ░   ▒    ░ ░  ░    ░   ░  ░  ░  ",
          " ░  ░  ░      ░  ░   ░       ░  ░      ░  ",
          "                   ░                      ",
          "      v0.7                         "
            .. string.format("Neovim v%d.%d.%d", vim.version().major, vim.version().minor, vim.version().patch),
        }, "\n"),
        sections = {
          {
            section = "header",
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    explorer = { enabled = false },
    image = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = false },
    notifier = { enabled = true },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  }
    require("hades.config.keybinds_plugins.snacks")
    require("snacks").setup(opts)
  end
}
