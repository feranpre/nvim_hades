local keys = require("config.utils.keymaps")

local M = {}

local function export(format, open)
	return function()
		require("config.utils.export").export(format, { open = open })
	end
end

-- Exportación de documentos (markdown, quarto, R markdown) con
-- <config>/scripts/md_to_pdf.py y las plantillas de scripts/templates/hades
function M.setup(buf)
	keys.buffer_group(buf, "n", "<localleader>e", "[e]xport")

	keys.buffer(buf, "n", "<localleader>ep", export("pdf"), "export to [p]df")

	keys.buffer(buf, "n", "<localleader>eh", export("html"), "export to [h]tml")

	keys.buffer(buf, "n", "<localleader>eP", export("pdf", true), "export to [P]df and open")

	keys.buffer(buf, "n", "<localleader>eH", export("html", true), "export to [H]tml and open")
end

return M
