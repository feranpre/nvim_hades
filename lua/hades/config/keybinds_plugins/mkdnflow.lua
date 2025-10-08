local keymap = require("hades.utils.keys").keymap
local keymap_buffer = require("hades.utils.keys").keymap_buffer
local key_or_clue = require("hades.utils.keys").key_or_clue

local opts = { noremap = true, silent = true, desc = nil }

if IsModuleAvailable("mkdnflow") then
  if DEBUG then
    print("mkdnflow - keys loaded")
  end

  key_or_clue("n", "<leader>m", "+[m]kdnflow options")
  keymap("n", "<leader>mf", "<cmd>MkdnFoldSection<CR>", opts, "[f]old section")
end
