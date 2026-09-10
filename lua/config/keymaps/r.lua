local keys = require("config.utils.keymaps")
local r = require("config.r")

local M = {}

function M.setup(buf)
	---------------------------------------------------------------------------
	-- R console
	---------------------------------------------------------------------------
	keys.buffer_group(buf, "n", "<localleader>r", "[r]un / execute")

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

	keys.buffer(buf, "n", "<S-Enter>", function()
		require("config.utils.r_send").smart()
	end, "smart run")

	---------------------------------------------------------------------------
	-- Objects
	---------------------------------------------------------------------------

	keys.buffer(buf, "n", "<localleader>p", "<Plug>RObjectPr", "[p]rint object")

	keys.buffer(buf, "n", "<localleader>h", "<Plug>RHelp", "[h]elp")

	keys.buffer(buf, "n", "<localleader>vd", "<Plug>RViewDFa", "[v]iew [d]ata.frame")

	keys.buffer(buf, "n", "<localleader>o", "<Plug>ROBToggle", "[o]bject inspector")

	---------------------------------------------------------------------------
	-- R package development
	---------------------------------------------------------------------------
	keys.buffer_group(buf, "n", "<localleader>b", "[b]uild / package")

	keys.buffer(buf, "n", "<localleader>bb", r.package_build, "[b]uild package")

	keys.buffer(buf, "n", "<localleader>bc", r.package_check, "[c]heck package")

	-- keys.buffer(buf, "n", "<localleader>bi", r.package_install, "[i]nstall package")
	keys.buffer(
		buf,
		"n",
		"<localleader>bi",
		"<cmd>lua require('r.send').cmd('devtools::install(args = \"--preclean --with-keep.source --no-multiarch\")')<CR>",
		"[i]nstall package"
	)

	-- keys.buffer(buf, "n", "<localleader>bl", r.package_load_all, "[l]oad package")
	keys.buffer(
		buf,
		"n",
		"<localleader>bl",
		"<cmd>lua require('r.send').cmd('devtools::load_all()')<CR>",
		"[l]oad package"
	)

	keys.buffer(buf, "n", "<localleader>bd", r.package_document, "[d]ocument package")

	keys.buffer(buf, "n", "<localleader>bn", r.package_new_test, "[n]ew test")

	keys.buffer(buf, "n", "<localleader>bt", r.package_test_file, "[t]est current file")

	keys.buffer(buf, "n", "<localleader>bT", r.package_test, "[T]est package")

	keys.buffer(buf, "n", "<localleader>bC", r.package_coverage, "[C]overage")

	-- Knit
	keys.buffer(
		buf,
		"n",
		"<localleader>kh",
		"<cmd>lua require('r.send').cmd('knitr::spin(\"' .. vim.api.nvim_buf_get_name(0) .. '\")')<CR>",
		"[s]pin R to HTML"
	)
end

return M
