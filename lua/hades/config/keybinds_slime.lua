--
-- This keybinds are only loaded when you enter one of this files:
--  - markdown
--  - quarto
--  - python
--
-- configuration_file: ~/.config/nvim/ftplugin/markdown.lua
-- configuration_file: ~/.config/nvim/ftplugin/quarto.lua
-- configuration_file: ~/.config/nvim/ftplugin/python.lua
--

--
-- SLIME
--
local M = {}
function M.load_keys(ev)
  local opts = require("hades.utils.keys").opts
  local keymap_buffer = require("hades.utils.keys").keymap_buffer
  local key_or_clue_buffer = require("hades.utils.keys").key_or_clue_buffer
  -- local send_full_expression = require("hades.utils.slime_commands").send_full_expression
  local send_expression_or_line = require("hades.utils.slime_commands").send_expression_or_line

  key_or_clue_buffer(ev.buf, "n", "<localleader>t", "+[t]erminal (Slime)")
  keymap_buffer(ev.buf, "n", "<localleader>tc", "<Plug>SlimeConfig", opts, "(Slime)[t]erminal [c]onf")
  if vim.g.slime_target == "neovim" then
    term = require("hades.utils.terminal")

    keymap_buffer(ev.buf, "n", "<localleader>tr", term.new_terminal_r, opts, "(Slime)new [t]erminal [r]")
    keymap_buffer(ev.buf, "n", "<localleader>tp", term.new_terminal_ipython, opts, "(Slime)new [t]erminal i[p]ython")
  end

  -- keymap_buffer(ev.buf, "n", "<C-CR>", "<Plug>SlimeLineSend<CR>", opts, "(Slime)[s]end [l]ine")
  -- keymap_buffer(ev.buf, "n", "<C-CR>", send_full_expression, opts, "(Slime)[s]end [l]ine")
  keymap_buffer(ev.buf, "n", "<C-CR>", send_expression_or_line, opts, "(Slime)[s]end [l]ine")
  keymap_buffer(ev.buf, "v", "<C-CR>", "<Plug>SlimeRegionSend<CR>", opts, "(Slime)[s]end region")

  keymap_buffer(ev.buf, "n", "<localleader>sl", "<Plug>SlimeLineSend<CR>", opts, "(Slime) [s]end [l]ine")
  keymap_buffer(ev.buf, "n", "<localleader>p", function()
    -- Get the word under the cursor
    local word = vim.fn.expand("<cword>")
    -- Create the print command
    local command = "print(" .. word .. ")\n"
    -- Send the command using vim-slime
    vim.fn["slime#send"](command)
  end, opts, "[p]rint variable")
  keymap_buffer(ev.buf, "n", "<localleader>sl", "<Plug>SlimeLineSend<CR>", opts, "(Slime) [s]end [l]ine")
  keymap_buffer(ev.buf, "v", "<localleader>sr", "<Plug>SlimeRegionSend<CR>", opts, "(Slime)[s]end [r]egion")
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
