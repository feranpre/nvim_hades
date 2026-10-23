local keys = require("config.utils.keymaps")

---------------------------------------------------------------------------
-- Insert mode
---------------------------------------------------------------------------
keys.map("i", "jk", "<Esc>", "escape insert mode")
keys.map("i", "kj", "<Esc>", "escape insert mode")

---------------------------------------------------------------------------
-- salir
---------------------------------------------------------------------------
keys.map("n", "<leader>qq", "<cmd>qa<CR>", "[q]uit [q]uit Neovim")
keys.map("n", "<leader>qn", function()
	require("config.utils.slides").new()
end, "[n]ew presentation (quarto)")

---------------------------------------------------------------------------
-- windows
---------------------------------------------------------------------------
keys.group("n", "<leader>w", "+[w]indow")

---------------------------------------------------------------------------
-- window creation
---------------------------------------------------------------------------
keys.map("n", "<leader>ww", "<C-w>p", "activate other [w]indow")
keys.map("n", "<leader>wd", "<C-w>c", "[d]elete window")
keys.map("n", "<leader>w-", "<C-w>s", "[s]plit window below")
keys.map("n", "<leader>w|", "<C-w>v", "split window [v]ertical (right)")

---------------------------------------------------------------------------
-- Window navigation
---------------------------------------------------------------------------
keys.map("n", "<leader>wh", "<C-w>h", "move to [l]eft window")
keys.map("n", "<leader>wj", "<C-w>j", "move to [d]own window")
keys.map("n", "<leader>wk", "<C-w>k", "move to [u]p window")
keys.map("n", "<leader>wl", "<C-w>l", "move to [r]ight window")

keys.map("n", "<C-h>", "<C-w>h", "move to [l]eft window")
keys.map("n", "<C-j>", "<C-w>j", "move to [d]own window")
keys.map("n", "<C-k>", "<C-w>k", "move to [u]p window")
keys.map("n", "<C-l>", "<C-w>l", "move to [r]ight window")

---------------------------------------------------------------------------
-- Window resize
---------------------------------------------------------------------------

keys.map("n", "<S-Right>", "<cmd>vertical resize +5<CR>", "widen window")
keys.map("n", "<S-Left>", "<cmd>vertical resize -5<CR>", "narrow window")
keys.map("n", "<S-Up>", "<cmd>resize +5<CR>", "increase window height")
keys.map("n", "<S-Down>", "<cmd>resize -5<CR>", "decrease window height")

---------------------------------------------------------------------------
-- Navigate buffers
---------------------------------------------------------------------------
keys.map("n", "<S-l>", "<cmd>bnext<CR>", "next buffer")
keys.map("n", "<S-h>", "<cmd>bprevious<CR>", "previous buffer")

---------------------------------------------------------------------------
-- Buffers
---------------------------------------------------------------------------

keys.group("n", "<leader>b", "[b]uffer")

keys.map("n", "<leader>bd", "<cmd>bdelete<CR>", "[d]elete buffer")

keys.map("n", "<leader>bD", function()
	local current = vim.api.nvim_get_current_buf()

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_get_option(buf, "buflisted") then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end, "[D]elete other buffers")

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
