local keymap = require("hades.utils.keys").keymap
local opts = { noremap = true, silent = true, desc = nil }

if DEBUG then
  print("udotree - keys loaded")
end

keymap("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", opts, "[u]ndoo tree")

