local M = {}

function M.load_keys(ev)
  if IsModuleAvailable("quarto") then
    local opts = require("hades.utils.keys").opts
    local keymap_buffer = require("hades.utils.keys").keymap_buffer

    keymap_buffer(ev.buf, "n", "<localleader>qps", "<cmd>QuartoPreview<cr>", opts, "[q]uarto [p]review [s]tart")
    keymap_buffer(ev.buf, "n", "<localleader>qpc", "<cmd>QuartoClosePreview<cr>", opts, "[q]uarto [p]review [c]lose")
  end
end

return M
