local keymap = require("hades.utils.keys").keymap
local keymap_buffer = require("hades.utils.keys").keymap_buffer
local key_or_clue = require("hades.utils.keys").key_or_clue

local opts = { noremap = true, silent = true, desc = nil }

--
-- TELESCOPE
--
if IsModuleAvailable("telescope") then
  if DEBUG then
    print("telescope - keys loaded")
  end
  key_or_clue("n", "<leader>f", "+[f]ind (telescope)")

  -- Telescope --
  -- Find files in project
  keymap("n", "<leader>ff", require("telescope.builtin").find_files, opts, "[f]ind [f]ile")
  keymap("n", "<leader>fk", require("telescope.builtin").keymaps, opts, "[f]ind [k]eymaps")
  keymap("n", "<leader>fr", require("telescope.builtin").oldfiles, opts, "[f]ind [r]ecent file")

  local live_multigrep = require("hades.utils.telescope_multigrep").live_multigrep
  keymap("n", "<leader>fg", live_multigrep, opts, "[f]ind string in this [d]ir")

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

local zotero_ok, _ = pcall(function()
  require("telescope").load_extension("zotero")
end)
  if zotero_ok then
    keymap("n", "<leader>zg", "<cmd>Telescope zotero<CR>", opts, "[z]otero [g]et reference")
  else
    print("no se ha cargado")
  end
else
  if DEBUG then
    print("telescope NOT DETECTED")
  end
end
