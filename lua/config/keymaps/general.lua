local map = vim.keymap.set
local keys = require("config.utils.keymaps")

-- Insert mode
map("i", "jk", "<Esc>", {
	desc = "escape insert mode",
})
map("i", "kj", "<Esc>", {
	desc = "escape insert mode",
})

-- salir
map("n", "<leader>qq", "<cmd>qa<CR>", {
	desc = "[q]uit [q]uit Neovim",
})

-- Window navigation
map("n", "<C-h>", "<C-w>h", {
	desc = "move to [l]eft window",
})

map("n", "<C-j>", "<C-w>j", {
	desc = "move to [d]own window",
})

map("n", "<C-k>", "<C-w>k", {
	desc = "move to [u]p window",
})

map("n", "<C-l>", "<C-w>l", {
	desc = "move to [r]ight window",
})

-- Navigate buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "previous buffer" })

-- Visual indentation
map("v", "<", "<gv", {
	desc = "indent left and keep selection",
})

map("v", ">", ">gv", {
	desc = "indent right and keep selection",
})

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", {
	desc = "move selection down",
})

map("v", "K", ":m '<-2<CR>gv=gv", {
	desc = "move selection up",
})

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
	desc = "clear search highlight",
})

-- Save
map("n", "<leader>w", "<cmd>write<CR>", {
	desc = "[w]rite buffer",
})

-- Quit
map("n", "<leader>q", "<cmd>quit<CR>", {
	desc = "[q]uit window",
})
