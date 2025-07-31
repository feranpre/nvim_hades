local keymap = require("hades.utils.keymap").keymap
local opts = require("hades.utils.keymap").opts

if DEBUG then
  print("   -- loaded keybinds for plugins")
end

--
-- WHICH-KEY 
--
local wk = require("which-key")

wk.add({
    {"a", mode = "v", group = "+select [a]round objects"},
    {"i", mode = "v", group = "+select [i]n objects"},
})


--
-- MASON
--
keymap("n", "<leader>mm", "<cmd>Mason<CR>", opts, "[m]ason")



--
-- OIL
--
keymap("n", "<leader>e", "<cmd>Oil<CR>", opts, "[e]xplore with Oil current directory")

--
-- TELESCOPE
--
-- local live_multigrep = require("hades.utils.telescope_multigrep").live_multigrep
if DEBUG then
  print("telescope - keys loaded")
end
-- key_or_clue("n", "<leader>f", "+[f]ind (telescope)")

keymap("n", "<leader>ff", require("telescope.builtin").find_files, opts, "[f]ind [f]ile")
keymap("n", "<leader>fk", require("telescope.builtin").keymaps, opts, "[f]ind [k]eymaps")
keymap("n", "<leader>fr", require("telescope.builtin").oldfiles, opts, "[f]ind [r]ecent file")
-- keymap("n", "<leader>fg", live_multigrep, opts, "[f]ind string in this [d]ir")
keymap("n", "<leader>fs", require("telescope.builtin").grep_string, opts, "[f]ind string under cursor in dir")
keymap(
  "n",
  "<leader>fb",
  require("telescope.builtin").current_buffer_fuzzy_find,
  opts,
  "[f]ind in [b]uffer (fuzzy find)"
)
keymap("n", "<leader>fB", require("telescope.builtin").buffers, opts, "[f]ind [b]uffer")
keymap("n", "<leader>fh", require("telescope.builtin").help_tags, opts, "[f]ind in [h]elp")
keymap("n", "<leader>fq", require("telescope.builtin").quickfix, opts, "[f]ind [q]uick fix")
keymap("n", "<leader>vc", require("telescope.builtin").colorscheme, opts, "[v]im [c]olosrcheme")
keymap("n", "<leader>fc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.stdpath("config"),
  })
end, opts, "[f]ind nvim [c]onfig file")

keymap("n", "z=", require("telescope.builtin").spell_suggest, opts, "[f]ind [b]uffer")

if require("telescope").extensions.zotero then
  keymap("n", "<leader>zg", "<cmd>Telescope zotero<CR>", opts, "[z]otero [g]et reference")
else
  print("no se ha cargado")
end


