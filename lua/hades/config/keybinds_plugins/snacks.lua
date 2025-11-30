local keymap = require("hades.utils.keys").keymap
local opts = { noremap = true, silent = true, desc = nil }

if DEBUG then
  print("snacks - keys loaded")
end

keymap("n", "<leader>fn", ":lua require('snacks').notifier.show_history()<CR>", opts, "[n]otifier show history (snacks) ")

