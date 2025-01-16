vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  desc = "REPL for multiple languages",
  pattern = { "python", "quarto" },
  callback = function(ev)
    print(" -- Loading Slime Keys --")
    local opts = { noremap = true, silent = true, desc = nil }
    local keymap = require("hades.utils.keys").keymap
    local keymap_buffer = require("hades.utils.keys").keymap_buffer
    local key_or_clue = require("hades.utils.keys").key_or_clue

    local function create_and_configure_terminal()
      -- Check if a terminal already exists in a split
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
          print("A terminal window already exists.")
          return
        end
      end
      local current_win = vim.api.nvim_get_current_win()
      --
      -- Open a terminal in a vertical split taking 30% of the space
      vim.cmd("vsplit")
      vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.3))

      vim.cmd("terminal")
      vim.cmd("$")

      -- Set the terminal buffer as the Slime target
      vim.g.slime_default_config = {
        jobid = vim.b.terminal_job_id,
      }
      vim.api.nvim_set_current_win(current_win)
      print("Terminal created and set as Slime target.")
    end

    key_or_clue("n", "<localleader>t", "+[t]erminal (Slime)")
    keymap_buffer(ev.buf, "n", "<localleader>tc", create_and_configure_terminal, opts, "(Slime)[t]erminal [n]ew conf")
    keymap_buffer(ev.buf, "n", "<localleader>tn", "<Plug>SlimeConfig", opts, "(Slime)[t]erminal [n]ew conf")

    -- SEND
    -- key_or_clue("n", "<localleader>s", "+[s] to terminal (Slime)")
    keymap("n", "<CR>", "<Plug>SlimeLineSend<CR>", opts, "(Slime)[s]end [l]ine")
    -- keymap_buffer(ev.buf, "n", "<C-CR>", "<Plug>SlimeLineSend<CR>", opts, "(Slime)[s]end [l]ine")
    keymap_buffer(ev.buf, "n", "<localleader>sl", "<Plug>SlimeLineSend<CR>", opts, "(Slime) [s]end [l]ine")

    -- keymap_buffer(ev.buf, "v", "<C-CR>", "<Plug>SlimeRegionSend<CR>", opts, "(Slime)[s]end region")
    keymap_buffer(ev.buf, "n", "<localleader>sr", "<Plug>SlimeRegionSend<CR>", opts, "(Slime)[s]end [r]egion")
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>sc",
      "<Plug>SlimeSendCell<BAR>/^" .. vim.g.slime_cell_delimiter .. "<CR>",
      opts,
      "(Slime)[s]end [c]ell"
    )
  end,
})
