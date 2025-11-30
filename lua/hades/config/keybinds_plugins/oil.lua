local keymap = require("hades.utils.keys").keymap
local opts = require("hades.utils.keys").opts

if DEBUG then
  print("oil - keys loaded")
end

keymap("n", "<leader>e", "<cmd>Oil<CR>", opts, "[e]xplore with Oil current directory")
