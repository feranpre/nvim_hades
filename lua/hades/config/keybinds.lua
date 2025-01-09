local live_multigrep = require("hades.misc.telescope_multigrep").live_multigrep

local keymap = require("hades.misc.utils").keymap
local keymap_buffer = require("hades.misc.utils").keymap_buffer
local key_or_clue = require("hades.misc.utils").key_or_clue
local isModuleAvailable = require("hades.misc.utils").isModuleAvailable

local debug = true
local opts = { noremap = true, silent = true, desc = nil }

-- local keymap = require("hades.misc.utils").keymap
-- local keymap_buffer = require("hades.misc.utils").keymap_buffer
-- local isModuleAvailable = require("hades.misc.utils").isModuleAvailable
-- local isAvailable = require("hades.misc.utils").isAvailable

if debug then
  print("Loading keys")
end
keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts, "open [L]azy window")

-- local generate_html_from_rscript = require("hades.misc.utils").generate_html_from_rscript
-- Define the function to call the pandoc2pdf.py script
-- keymap("n", "<leader>p", "<cmd>lua PandocToPDF()<CR>", opts, "pdf")

keymap("n", "<leader><leader>x", "<cmd>source %<cr>", opts, "e[x]ecute fiel (source)")

-- Press jk fast to enter
keymap("i", "kj", "<ESC>", opts, "exit insert mode")
keymap("n", "<ESC>", "<cmd>nohl<cr>", opts, "remove hilights")

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
-- key_or_clue("n", "<leader>b", "+[b]uffer options")
-- keymap("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", opts, "[b]uffer [d]elete")
-- keymap("n", "<leader>bD", "<cmd>%bd|e#<CR>", opts, "[b]uffer [D]elete all but current")

-- indenting
keymap("v", "<", "<gv", opts, "un-Indent selected text")
keymap("v", ">", ">gv", opts, "indent selected text")

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Spelling --
keymap("n", "]s", "]s", opts, "next misspelled word")
keymap("n", "[s", "[s", opts, "prev misspelled word")
keymap("n", "zg", "zg", opts, "[g]ood word to add to dictionary (spelling)")
keymap("n", "zG", "zG", opts, "[G]ood word to add to internal dictionary (spelling)")
keymap("n", "zug", "zug", opts, "[u]ndo add [g]ood word to dictionary (spelling)")
keymap("n", "zuG", "zuG", opts, "[u]ndo add [G]ood word to internal dictionary (spelling)")
keymap("n", "zw", "zw", opts, "[w]rong word to add to dictionary (spelling)")
keymap("n", "zW", "zW", opts, "[W]rong word to add to internal dictionary (spelling)")
keymap("n", "z=", "z=", opts, "check possible replacements for word (spelling)")


-- -------------------------------------
-- ------------------------------------- TELESCOPE
-- -------------------------------------
if isModuleAvailable("telescope") then
  if debug then
    print("telescope - keys loaded")
  end
  key_or_clue("n", "<leader>f", "+[f]ind (telescope)")

  -- Telescope --
  -- Find files in project
  keymap("n", "<leader>ff", require("telescope.builtin").find_files, opts, "[f]ind [f]ile")
  keymap("n", "<leader>fk", require("telescope.builtin").keymaps, opts, "find [k]eymaps")
  keymap("n", "<leader>fr", require("telescope.builtin").oldfiles, opts, "find [r]ecent file")
  keymap("n", "<leader>fs", live_multigrep, opts, "find string in this [d]ir")
  keymap("n", "<leader>fg", require("telescope.builtin").grep_string, opts, "find string under cursor in dir")
  keymap("n", "<leader>fb", require("telescope.builtin").current_buffer_fuzzy_find, opts, "find in [b]uffer (fuzzy find)")
  keymap("n", "<leader>fB", require("telescope.builtin").buffers, opts, "find [b]uffer")
  keymap("n", "<leader>fh", require("telescope.builtin").help_tags, opts, "find in [h]elp")
  keymap("n", "<leader>fq", require("telescope.builtin").quickfix, opts, "find [q]uick fix")
  keymap("n", "<leader>vc", require("telescope.builtin").colorscheme, opts, "[v]im [c]olosrcheme")
  keymap("n", "<leader>fc", function()
    require("telescope.builtin").find_files {
      cwd = vim.fn.stdpath("config")
    }
  end
  , opts, "[f]ind nvim [c]onfig file")
end
