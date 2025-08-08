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
        " v0.3",
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

      -- Get Neovim version
      local v = vim.version()
      local nvim_version = string.format("Neovim v%d.%d.%d", v.major, v.minor, v.patch)

      -- Custom fortune quotes
      local quotes = {
        { "Correlation doesn't mean causation", "", "— 🦦" },
        { "Never memorize something you can look up", "", "— Einstein" },
        { "Somewhere, something incredible is waiting to be known", "", "— Carl Sagan" },
        { "If I have seen further it is by standing on the shoulders of giants", "", "— Newton" },
      }

      -- Pick a random quote
      math.randomseed(os.time())
      local quote = quotes[math.random(#quotes)]

      -- Combine quote and version
      local footer = vim.deepcopy(quote)
      table.insert(footer, "") -- empty line
      table.insert(footer, "") -- empty line
      table.insert(footer, "") -- empty line
      table.insert(footer, nvim_version)

      -- Set footer
      dashboard.section.footer.val = footer
      dashboard.section.footer.opts = {
        position = "center",
        hl = "Comment",
      }
      -- Send config to alpha
      alpha.setup(dashboard.opts)
    end,
  },
}
