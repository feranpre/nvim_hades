return {
  "michaelb/sniprun",
  branch = "master",

  build = "sh install.sh",
  -- do 'sh install.sh 1' if you want to force compile locally
  -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

  config = function()
    require("sniprun").setup({
      display = {
        -- "VirtualText",
        -- "Terminal",
        "TerminalWithCode",
      },
      display_options = {
        terminal_position = "vertical", --# or "horizontal", to open as horizontal split instead of vertical split
        -- terminal_height = 5, --# change the terminal display option height (if horizontal)
        terminal_width = 20,          --# change the terminal display option height (if horizontal)
      },
      repl_enable = {
        "R",
      },
      interpreter_options = {
        Python3_original = {
          interpreter = "python",
          venv = { "pandas" },
        }
      }
    })
  end,
}
