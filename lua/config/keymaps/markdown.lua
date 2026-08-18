local keys = require("config.utils.keymaps")

local M = {}

function M.setup(buf)
	keys.buffer(buf, "n", "<S-Enter>", function()
		require("config.utils.markdown_runner").run_cell()
	end, "smart run [c]ell")

	keys.buffer(buf, "n", "<localleader>ft", "za", "toggle [f]old")
end

return M
