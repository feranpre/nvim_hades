local keys = require("config.utils.keymaps")

local M = {}

function M.setup(buf)
	keys.buffer(buf, "n", "<S-Enter>", function()
		require("config.utils.markdown_runner").run_cell()
	end, "smart run [c]ell")

	---------------------------------------------------------------------------
	-- Export (pandoc, scripts en <config>/scripts)
	---------------------------------------------------------------------------
	keys.buffer_group(buf, "n", "<localleader>k", "[k]nit / export")

	keys.buffer(buf, "n", "<localleader>kp", function()
		require("config.utils.pandoc").convert("pdf")
	end, "export to [p]df")

	keys.buffer(buf, "n", "<localleader>kh", function()
		require("config.utils.pandoc").convert("html")
	end, "export to [h]tml")

	keys.buffer(buf, "n", "<localleader>ku", function()
		require("config.utils.pandoc").convert("utamed")
	end, "export to [u]tamed pdf")
end

return M
