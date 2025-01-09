return {
  -- dashboard to greet
  {
    "goolord/alpha-nvim",
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Set header
      dashboard.section.header.val = {
        "    ▄█    █▄       ▄████████ ████████▄     ▄████████    ▄████████ ",
        "   ███    ███     ███    ███ ███   ▀███   ███    ███   ███    ███ ",
        "   ███    ███     ███    ███ ███    ███   ███    █▀    ███    █▀  ",
        "  ▄███▄▄▄▄███▄▄   ███    ███ ███    ███  ▄███▄▄▄       ███        ",
        " ▀▀███▀▀▀▀███▀  ▀███████████ ███    ███ ▀▀███▀▀▀     ▀███████████ ",
        "   ███    ███     ███    ███ ███    ███   ███    █▄           ███ ",
        "   ███    ███     ███    ███ ███   ▄███   ███    ███    ▄█    ███ ",
        "   ███    █▀      ███    █▀  ████████▀    ██████████  ▄████████▀  ",
        " ",
        " v0.2",
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰈞  > Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("l", "  > Lazy", ":Lazy<CR>"),
        dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h<cr>"),
        dashboard.button("q", "󰅚  > Quit NVIM", ":qa<CR>"),
      }

      local fortune = require("alpha.fortune")
      dashboard.section.footer.val = fortune({
        fortune_list = {
          { "Correlation doesn't mean causation", "", "— 🦦" },
          { "Never memorize something you can look p", "", "— Einstein" },
          { "Somewhere, something incredible is waiting to be known", "", "Carl Sagan" },
          { "If I have seen further is by standing on the shoulders of giants", "", "Newton" },
        },
      })

      -- Send config to alpha
      alpha.setup(dashboard.opts)
    end,
  },
}
