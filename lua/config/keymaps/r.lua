local keys = require("config.utils.keymaps")

local M = {}

function M.setup(buf)
	---------------------------------------------------------------------------
	-- R console
	---------------------------------------------------------------------------

	keys.buffer(buf, "n", "<localleader>rs", "<Plug>RStart", "[s]tart R console")

	keys.buffer(buf, "n", "<localleader>rq", "<Plug>RClose", "[q]uit R console")

	keys.buffer(buf, "n", "<localleader>rw", "<Plug>RSaveClose", "quit and [w]rite R console")

	keys.buffer(buf, "n", "<localleader>rc", "<Plug>RClearConsole<CR>", "clear R [c]onsole")

	---------------------------------------------------------------------------
	-- Execution
	---------------------------------------------------------------------------

	keys.buffer(buf, "n", "<localleader>rl", "<Plug>RDSendLine", "run [l]ine")

	keys.buffer(buf, "v", "<localleader>rl", "<Plug>RDSendSelection", "run selected [l]ines")

	keys.buffer(buf, "n", "<localleader>rp", "<Plug>RDSendParagraph", "run [p]aragraph")

	keys.buffer(buf, "n", "<localleader>rf", "<Plug>RSendFile", "run [f]ile")

	---------------------------------------------------------------------------
	-- Objects
	---------------------------------------------------------------------------

	keys.buffer(buf, "n", "<localleader>p", "<Plug>RObjectPr", "[p]rint object")

	keys.buffer(buf, "n", "<localleader>h", "<Plug>RHelp", "[h]elp")

	keys.buffer(buf, "n", "<localleader>vd", "<Plug>RViewDFa", "[v]iew [d]ata.frame")

	keys.buffer(buf, "n", "<localleader>o", "<Plug>ROBToggle", "[o]bject inspector")
end

return M
