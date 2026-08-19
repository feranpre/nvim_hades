local map = vim.keymap.set
local keys = require("config.utils.keymaps")

-- Insert mode
keys.map("i", "jk", "<Esc>", "escape insert mode")
keys.map("i", "kj", "<Esc>", "escape insert mode")

-- salir
keys.map("n", "<leader>qq", "<cmd>qa<CR>", "[q]uit [q]uit Neovim")

-- Window navigation
keys.group("n", "<leader>w", "+[w]indow")
keys.map("n", "<leader>wh", "<C-w>h", "move to [l]eft window")
keys.map("n", "<leader>wj", "<C-w>j", "move to [d]own window")
keys.map("n", "<leader>wk", "<C-w>k", "move to [u]p window")
keys.map("n", "<leader>wl", "<C-w>l", "move to [r]ight window")

keys.map("n", "<C-h>", "<C-w>h", "move to [l]eft window")
keys.map("n", "<C-j>", "<C-w>j", "move to [d]own window")
keys.map("n", "<C-k>", "<C-w>k", "move to [u]p window")
keys.map("n", "<C-l>", "<C-w>l", "move to [r]ight window")

-- Navigate buffers
keys.map("n", "<S-l>", "<cmd>bnext<CR>", "next buffer")
keys.map("n", "<S-h>", "<cmd>bprevious<CR>", "previous buffer")

-- Visual indentation
keys.map("v", "<", "<gv", "indent left and keep selection")

keys.map("v", ">", ">gv", "indent right and keep selection")

-- Move selected lines
keys.map("v", "J", ":m '>+1<CR>gv=gv", "move selection down")

keys.map("v", "K", ":m '<-2<CR>gv=gv", "move selection up")

-- Clear search highlight
keys.map("n", "<Esc>", "<cmd>nohlsearch<CR>", "clear search highlight")

-- Save
-- keys.map("n", "<leader>w", "<cmd>write<CR>", "[w]rite buffer")

keys.map("n", "C-s", "<cmd>write<CR>", "[w]rite buffer")

-- Quit
keys.map("n", "<leader>q", "<cmd>quit<CR>", "[q]uit window")
