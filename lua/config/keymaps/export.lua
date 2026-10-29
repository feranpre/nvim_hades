local keys = require("config.utils.keymaps")

local M = {}

-- Exportación de documentos (markdown, quarto, R markdown)
function M.setup(buf)
	local export = require("config.utils.export")

	keys.buffer_group(buf, "n", "<localleader>k", "[k]nit / export")

	keys.buffer(buf, "n", "<localleader>kp", function()
		export.export("pdf")
	end, "export to [p]df")

	keys.buffer(buf, "n", "<localleader>kh", function()
		export.export("html")
	end, "export to [h]tml")

	keys.buffer(buf, "n", "<localleader>kP", function()
		export.export("pdf", { open = true })
	end, "export to [P]df and open")

	keys.buffer(buf, "n", "<localleader>kH", function()
		export.export("html", { open = true })
	end, "export to [H]tml and open")
end

return M
