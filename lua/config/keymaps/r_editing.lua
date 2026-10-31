local keys = require("config.utils.keymaps")

local M = {}

-- Atajos de escritura de R en modo inserción (acciones de R.nvim, que con
-- user_maps_only = true no tienen atajo propio). Como en RStudio:
--   <M-->  " <- "   (solo dentro de código R)
--   <M-m>  " |> "
--   <M-r>  nuevo chunk de R (markdown / quarto / R markdown)
function M.setup(buf, opts)
	opts = opts or {}

	keys.buffer(buf, "i", "<M-->", "<Plug>RInsertAssign", "insert <- (assign)")

	keys.buffer(buf, "i", "<M-m>", "<Plug>RInsertPipe", "insert |> (pipe)")

	if opts.chunks then
		keys.buffer(buf, "i", "<M-r>", "<Plug>RmdInsertChunk", "insert R chunk")
	end
end

return M
