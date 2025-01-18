--
-- MOLTEN
--
local M = {}

function M.load_keys(ev)
  local opts = { noremap = true, silent = true, desc = nil }
  local keymap_buffer = require("hades.utils.keys").keymap_buffer
  local unbind_key = require("hades.utils.keys").unbind_key
  local key_or_clue = require("hades.utils.keys").key_or_clue

  -- keymap_buffer(ev.buf, "n", "<C-CR>", "<cmd>MoltenEvaluateLine<CR>", opts, "Evaluate Line (molten)")
  keymap_buffer(ev.buf, "n", "<localleader>ml", "<cmd>MoltenEvaluateLine<CR>", opts, "Evaluate Line (molten)")
  keymap_buffer(ev.buf, "n", "<localleader>mi", "<cmd>MoltenInit<CR>", opts, "[m]olten [i]nit (molten)")

  if Molten_or_Slime == "molten" then
    keymap_buffer(ev.buf, "n", "<C-CR>", "<cmd>MoltenEvaluateLine<CR>", opts, "Evaluate Line (molten)")
    keymap_buffer(ev.buf, "v", "<C-CR>", ":<C-u>MoltenEvaluateVisual<CR>gv<ESC>", opts, "Evaluate Visual (molten)")
    -- keymap_buffer(ev.buf, "v", "<localleader>e", ":<C-u>MoltenEvaluateVisual<CR>gv", opts, "Evaluate Visual (molten)")

    -- unbind_key("n", "<localleader>M", 0)
  else
    keymap_buffer(ev.buf, "n", "<localleader>M", function()
      print("switching to Slime")
      Molten_or_Slime = "molten"
      vim.api.nvim_buf_del_keymap(0, "n", "<localleader>M")
      -- unbind_key("n", "<localleader>M", 0)
      require("hades.config.keybinds_molten").load_keys(ev)
      require("hades.config.keybinds_slime").load_keys(ev)
    end, opts, "<C-CR> -> (Molten)")
  end
end

return M
