local keymap = require("hades.utils.keys").keymap
-- local keymap_buffer = require("hades.utils.keys").keymap_buffer
local key_or_clue = require("hades.utils.keys").key_or_clue

local opts = { noremap = true, silent = true, desc = nil }

--
-- OIL
--
if IsModuleAvailable("oil") then
  if DEBUG then
    print("oil - keys loaded")
  end
  keymap("n", "<leader>e", "<cmd>Oil<CR>", opts, "[e]xplore with Oil current directory")
end

if IsModuleAvailable("undotree") then
  if DEBUG then
    print("udotree - keys loaded")
  end
  keymap("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", opts, "[u]ndoo tree")
end
