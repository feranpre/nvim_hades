local keymap = require("hades.utils.keys").keymap
local opts = require("hades.utils.keys").opts

if DEBUG then
  print("harpoon - keys loaded")
end

local harpoon = require("harpoon")
keymap("n", "<leader>a", function()
  harpoon:list():add()
end, opts, "[a]dd file to harpoon list")
keymap("n", "<C-q>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, opts, "[q]uick harpoon list")
keymap("n", "<leader>A", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, opts, "[q]uick harpoon list")


keymap("n", "<C-1>", function()
  harpoon:list():select(1)
end, opts, "harpoon list - 1")
keymap("n", "<C-2>", function()
  harpoon:list():select(2)
end, opts, "harpoon list - 2")
keymap("n", "<C-3>", function()
  harpoon:list():select(3)
end, opts, "harpoon list - 3")
keymap("n", "<C-4>", function()
  harpoon:list():select(4)
end, opts, "harpoon list - 4")
keymap("n", "<C-5>", function()
  harpoon:list():select(5)
end, opts, "harpoon list - 5")
keymap("n", "<C-6>", function()
  harpoon:list():select(6)
end, opts, "harpoon list - 6")
keymap("n", "<C-7>", function()
  harpoon:list():select(7)
end, opts, "harpoon list - 7")
keymap("n", "<C-8>", function()
  harpoon:list():select(8)
end, opts, "harpoon list - 8")
keymap("n", "<C-9>", function()
  harpoon:list():select(9)
end, opts, "harpoon list - 9")

-- Toggle previous & next buffers stored within Harpoon list
keymap("n", "<C-S-P>", function()
  harpoon:list():prev()
end, opts, "[p]revious harpool file")
keymap("n", "<C-S-N>", function()
  harpoon:list():next()
end, opts, "[n]ext harpoon file")


