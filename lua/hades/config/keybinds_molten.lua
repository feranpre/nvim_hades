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
--
-- MOLTEN
--

-- local opts = { noremap = true, silent = true, desc = nil }
local opts = require("hades.utils.keys").opts
local keymap_buffer = require("hades.utils.keys").keymap_buffer
local unbind_key = require("hades.utils.keys").unbind_key
local key_or_clue = require("hades.utils.keys").key_or_clue

-- keymap_buffer(0, "n", "<C-CR>", "<cmd>MoltenEvaluateLine<CR>", opts, "Evaluate Line (molten)")
keymap_buffer(0, "n", "<localleader>ml", "<cmd>MoltenEvaluateLine<CR>", opts, "Evaluate Line (molten)")
keymap_buffer(0, "n", "<localleader>mi", "<cmd>MoltenInit<CR>", opts, "[m]olten [i]nit (molten)")

if Molten_or_Slime == "molten" then
  keymap_buffer(0, "n", "<C-CR>", "<cmd>MoltenEvaluateLine<CR>", opts, "Evaluate Line (molten)")
  keymap_buffer(0, "v", "<C-CR>", ":<C-u>MoltenEvaluateVisual<CR>gv<ESC>", opts, "Evaluate Visual (molten)")
  -- keymap_buffer(0, "v", "<localleader>e", ":<C-u>MoltenEvaluateVisual<CR>gv", opts, "Evaluate Visual (molten)")

  -- unbind_key("n", "<localleader>M", 0)
else
  keymap_buffer(0, "n", "<localleader>M", function()
    print("switching to Slime")
    Molten_or_Slime = "molten"
    vim.api.nvim_buf_del_keymap(0, "n", "<localleader>M")
    -- unbind_key("n", "<localleader>M", 0)
    require("hades.config.keybinds_molten").load_keys(ev)
    require("hades.config.keybinds_slime").load_keys(ev)
  end, opts, "<C-CR> -> (Molten)")
end
