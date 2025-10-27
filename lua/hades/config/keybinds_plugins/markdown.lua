local M = {}

function M.load_keys(ev)
  local opts = require("hades.utils.keys").opts
  local keymap_buffer = require("hades.utils.keys").keymap_buffer

  keymap_buffer(ev.buf, "n", "<localleader>mep", "<cmd>MdToPdf<cr>", opts, "[m]arkdown [e]xport [p]df")
end

return M
