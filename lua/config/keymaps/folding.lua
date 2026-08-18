local keys = require("config.utils.keymaps")

local M = {}

function M.setup(buf)
	keys.buffer(buf, "n", "<localleader>ft", "za", "[t]oggle fold")

	keys.buffer(buf, "n", "<localleader>fo", "zo", "[o]pen fold")

	keys.buffer(buf, "n", "<localleader>fc", "zc", "[c]lose fold")

	keys.buffer(buf, "n", "<localleader>fO", "zR", "[o]pen all folds")

	keys.buffer(buf, "n", "<localleader>fC", "zM", "[c]lose all folds")
end

return M
