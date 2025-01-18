--
-- SLIME
--
local M = {}

function M.load_keys(ev)
  local opts = { noremap = true, silent = true, desc = nil }
  local unbind_key = require("hades.utils.keys").unbind_key
  local keymap = require("hades.utils.keys").keymap
  local keymap_buffer = require("hades.utils.keys").keymap_buffer
  local key_or_clue = require("hades.utils.keys").key_or_clue
  local new_terminal_r = require("hades.utils.terminal").new_terminal_r
  local new_terminal_python = require("hades.utils.terminal").new_terminal_python

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
  key_or_clue("n", "<localleader>tn", "+[t]erminal [n]ew (Slime)")
  keymap_buffer(ev.buf, "n", "<localleader>tnr", new_terminal_r, opts, "(Slime)[t]erminal [n]ew for [r]")
  keymap_buffer(ev.buf, "n", "<localleader>tnp", new_terminal_python, opts, "(Slime)[t]erminal [n]ew for [p]ython")
  keymap_buffer(ev.buf, "n", "<localleader>tc", "<Plug>SlimeConfig", opts, "(Slime)[t]erminal [c]onf")

  if Molten_or_Slime == "slime" then
    keymap_buffer(ev.buf, "n", "<C-CR>", "<Plug>SlimeLineSend<CR>", opts, "(Slime)[s]end [l]ine")
    keymap_buffer(ev.buf, "v", "<C-CR>", "<Plug>SlimeRegionSend<CR>", opts, "(Slime)[s]end region")
    -- unbind_key("n", "<localleader>S", 0)
  else
    keymap_buffer(ev.buf, "n", "<localleader>S", function()
      print("switching to Molten")
      Molten_or_Slime = "slime"
      vim.api.nvim_buf_del_keymap(0, "n", "<localleader>S")
      -- unbind_key("n", "<localleader>S", 0)
      require("hades.config.keybinds_molten").load_keys(ev)
      require("hades.config.keybinds_slime").load_keys(ev)
    end, opts, "<C-CR> -> (Slime)")
  end

  -- SEND
  -- key_or_clue("n", "<localleader>s", "+[s] to terminal (Slime)")
  -- keymap("n", "<CR>", "<Plug>SlimeLineSend<CR>", opts, "(Slime)[s]end [l]ine")
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
end

return M
