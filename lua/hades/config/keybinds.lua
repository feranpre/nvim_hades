-- TODO: limpiar comentarios

local keymap = require("hades.utils.keys").keymap
local key_or_clue = require("hades.utils.keys").key_or_clue

local opts = require("hades.utils.keys").opts
-- local opts = { noremap = true, silent = true, desc = nil }

if DEBUG then
  print("Loading keys")
end

keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts, "open [L]azy window")
keymap("n", "<leader><leader>x", "<cmd>source %<cr>", opts, "e[x]ecute fiel (source)")

-- Press jk fast to enter
keymap("i", "kj", "<ESC>", opts, "exit insert mode")
-- keymap("n", "kj", "<ESC>", opts, "ESC")
-- keymap("v", "kj", "<ESC>", opts, "ESC")
keymap("n", "<ESC>", "<cmd>nohl<cr>", opts, "remove hilights")

-- Move down and center screen

keymap("n", "<C-d>", "<C-d>zz", opts, "half-page down and center")
keymap("n", "<C-u>", "<C-u>zz", opts, "half-page up and center")

-- Navigate buffers
keymap("n", "<S-l>", "<cmd>bnext<CR>", opts, "next buffer")
keymap("n", "<S-h>", "<cmd>bprevious<CR>", opts, "previous buffer")
keymap("n", "<C-q>", "<cmd>q<CR>", opts, "[q]uit buffer")

-- save file
keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", opts, "[s]ave file")
keymap("n", "<leader>qq", "<cmd>qa<cr>", opts, "[q]uit all")

-- Uber yank --
keymap({ "n", "v" }, "<leader>y", '"+y', opts, "[y]ank out of nvim")

-- window creation
key_or_clue("n", "<leader>w", "+[w]indow options")
keymap("n", "<leader>ww", "<C-w>p", opts, "activate other [w]indow")
keymap("n", "<leader>wd", "<C-w>c", opts, "[d]elete window")
keymap("n", "<leader>w-", "<C-w>s", opts, "[s]plit window below")
keymap("n", "<leader>w|", "<C-w>v", opts, "split window [v]ertical (right)")

-- window resize
keymap("n", "<S-Up>", "<cmd>resize +2<CR>", opts, "resize window [u]p")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>", opts, "resize window [d]own")
keymap("n", "<S-Left>", "<cmd>vertical resize +2<CR>", opts, "resize window [l]eft")
keymap("n", "<S-Right>", "<cmd>vertical resize -2<CR>", opts, "resize window [r]ight")

keymap("n", "<C-S-k>", "<cmd>resize +2<CR>", opts, "resize window [u]p")
keymap("n", "<C-S-j>", "<cmd>resize -2<CR>", opts, "resize window [d]own")
keymap("n", "<C-S-h>", "<cmd>vertical resize +2<CR>", opts, "resize window [l]eft")
keymap("n", "<C-S-l>", "<cmd>vertical resize -2<CR>", opts, "resize window [r]ight")

keymap("n", "<leader>wk", "<cmd>resize +2<CR>", opts, "resize window [u]p <C-S-k>")
keymap("n", "<leader>wj", "<cmd>resize -2<CR>", opts, "resize window [d]own <C-S-j>")
keymap("n", "<leader>wh", "<cmd>vertical resize +2<CR>", opts, "resize window [l]eft <C-S-l>")
keymap("n", "<leader>wl", "<cmd>vertical resize -2<CR>", opts, "resize window [r]ight <C-S-h>")

-- window rotation
keymap("n", "<leader>wK", "<C-w>K", opts, "move window to the top [<C-w>K]")
keymap("n", "<leader>wJ", "<C-w>J", opts, "move window to the bottom [<C-w>J]")
keymap("n", "<leader>wL", "<C-w>L", opts, "move window to the left [<C-w>L]")
keymap("n", "<leader>wH", "<C-w>H", opts, "move window to the right [<C-w>H]")

-- buffer
key_or_clue("n", "<leader>b", "+[b]uffer options")
keymap("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", opts, "[b]uffer [d]elete")
keymap("n", "<leader>bD", "<cmd>%bd|e#<CR>", opts, "[b]uffer [D]elete all but current")

-- indenting
keymap("v", "<", "<gv", opts, "un-Indent selected text")
keymap("v", ">", ">gv", opts, "indent selected text")

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Spelling --
keymap("n", "]s", "]s", opts, "next misspelled word")
keymap("n", "[s", "[s", opts, "prev misspelled word")
keymap("n", "zg", "zg", opts, "[g]ood word to add to dictionary (spelling)")
-- keymap("n", "zG", "zG", opts, "[G]ood word to add to internal dictionary (spelling)")
keymap("n", "zug", "zug", opts, "[u]ndo add [g]ood word to dictionary (spelling)")
-- keymap("n", "zuG", "zuG", opts, "[u]ndo add [G]ood word to internal dictionary (spelling)")
keymap("n", "zw", "zw", opts, "[w]rong word to add to dictionary (spelling)")
-- keymap("n", "zW", "zW", opts, "[W]rong word to add to internal dictionary (spelling)")
keymap("n", "z=", "z=", opts, "check possible replacements for word (spelling)")

-- TERMINAL --
keymap("t", "<ESC>", [[<C-\><C-n>]], opts, "exit insertmode in terminal")



-- -- FOLD --
-- -- Keymap for folding markdown headings of level 1 or above
-- keymap("n", "zh4", function()
--   require("hades.utils.folds").fold_markdown_headings({ 6, 5, 4 })
-- end, opts, "fold [h]eaders lvl 4 and below")
--
-- keymap("n", "zh3", function()
--   require("hades.utils.folds").fold_markdown_headings({ 6, 5, 4, 3 })
-- end, opts, "fold [h]eaders lvl 3 and below")
--
-- keymap("n", "zh2", function()
--   require("hades.utils.folds").fold_markdown_headings({ 6, 5, 4, 3, 2 })
-- end, opts, "fold [h]eaders lvl 2 and below")

-- LSP --
keymap("v", "<leader>lf", vim.lsp.buf.format, opts, "[l]sp [f]ormat visual selection")
