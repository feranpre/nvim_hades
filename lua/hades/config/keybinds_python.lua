local M = {}

function M.load_keys(ev)
  require("hades.utils.python_commands")

  local keymap_buffer = require("hades.utils.keys").keymap_buffer
  local key_or_clue_buffer = require("hades.utils.keys").key_or_clue_buffer
  local opts = require("hades.utils.keys").opts

  keymap_buffer(ev.buf, "n", "<localleader>em", "<cmd>PythonToMd<CR>", opts, "[e]xport to [m]arkdown")
end
return M
