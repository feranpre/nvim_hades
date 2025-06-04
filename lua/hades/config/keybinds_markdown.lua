--
-- This keybinds are only loaded when a markdown file is entered
--
-- configuration_file: ~/.config/nvim/ftplugin/markdown.lua
--
local M = {}

function M.load_keys(ev)
  require("hades.utils.markdown_commands")

  local keymap_buffer = require("hades.utils.keys").keymap_buffer
  local key_or_clue_buffer = require("hades.utils.keys").key_or_clue_buffer
  local opts = require("hades.utils.keys").opts

  keymap_buffer(
    ev.buf,
    "n",
    "<localleader>mhn",
    "<cmd>MdNumberHeadings<CR>",
    opts,
    "[m]arkdown [h]eadings [n]umeration"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<localleader>mhN",
    "<cmd>MdRemoveNumberHeadings<CR>",
    opts,
    "[m]arkdown [h]eadings [N]umeration remove"
  )
  keymap_buffer(ev.buf, "n", "<localleader>mt", "<cmd>MdGenerateTOC<CR>", opts, "[m]arkdown [t]oc")
  keymap_buffer(ev.buf, "n", "<localleader>mo", "<cmd>Outline<CR>", opts, "[m]arkdown [o]utline")
  keymap_buffer(ev.buf, "n", "<localleader>gl", "<cmd>MdJumpToTOCLink<CR>", opts, "[g]arkdown to [l]ink")

  key_or_clue_buffer(ev.buf, "n", "<localleader>e", "[e]xport markdown file")

  keymap_buffer(ev.buf, "n", "<localleader>ep", "<cmd>MdToPDF<CR>", opts, "[e]xport to [p]df")
  keymap_buffer(ev.buf, "n", "<localleader>eh", "<cmd>MdToHTML<CR>", opts, "[e]xport to [h]tml")

end
return M
