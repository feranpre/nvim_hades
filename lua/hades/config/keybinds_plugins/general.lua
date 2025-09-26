local keymap = require("hades.utils.keys").keymap
-- local keymap_buffer = require("hades.utils.keys").keymap_buffer
local key_or_clue = require("hades.utils.keys").key_or_clue

local opts = { noremap = true, silent = true, desc = nil }

--
-- OIL
--
if IsModuleAvailable("oil") then
  keymap("n", "<leader>e", "<cmd>Oil<CR>", opts, "[e]xplore with Oil current directory")
end

key_or_clue("x", "g<C-a>", "inc [++] num")
key_or_clue("x", "g<C-x>", "dec [--] num")
