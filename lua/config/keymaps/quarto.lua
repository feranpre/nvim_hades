local keys = require("config.utils.keymaps")

local M = {}

function M.setup(buf)
	local runner = require("quarto.runner")
	local quarto = require("quarto")

	---------------------------------------------------------------------------
	-- Quarto document
	---------------------------------------------------------------------------
	keys.buffer_group(buf, "n", "<localleader>q", "[q]uarto")

	keys.buffer(buf, "n", "<localleader>qr", "<cmd>QuartoRender<CR>", "[q]uarto [r]ender")

	keys.buffer(buf, "n", "<localleader>qp", "<cmd>QuartoPreview<CR>", "[q]uarto [p]review")

	keys.buffer(buf, "n", "<localleader>qs", "<cmd>QuartoClosePreview<CR>", "[q]uarto [s]top preview")

	---------------------------------------------------------------------------
	-- Presentaciones (reveal.js, plantilla en <config>/scripts/templates/slides)
	---------------------------------------------------------------------------
	local slides = require("config.utils.slides")

	keys.buffer(buf, "n", "<localleader>qn", slides.new, "[n]ew presentation")

	keys.buffer(buf, "n", "<localleader>qh", slides.html, "slides to [h]tml")

	keys.buffer(buf, "n", "<localleader>qP", slides.pdf, "slides to [P]DF (decktape)")

	---------------------------------------------------------------------------
	-- Code
	---------------------------------------------------------------------------

	keys.buffer(buf, "n", "<localleader>rc", runner.run_cell, "run [c]ell")

	keys.buffer(buf, "n", "<localleader>rl", runner.run_line, "run [l]ine")

	keys.buffer(buf, "n", "<localleader>ra", runner.run_above, "run cell and [a]bove")

	keys.buffer(buf, "n", "<localleader>rb", runner.run_below, "run cell and [b]elow")

	-- keys.buffer(buf, "n", "<localleader>rA", runner.run_all, "run [a]ll cells")

	keys.buffer(buf, "v", "<localleader>rr", runner.run_range, "run [r]ange")

	---------------------------------------------------------------------------
	-- All languages
	---------------------------------------------------------------------------

	keys.buffer(buf, "n", "<localleader>rA", function()
		runner.run_all(true)
	end, "run [a]ll cells / languages")

	keys.buffer(buf, "n", "<S-Enter>", runner.run_cell, "smart run [c]ell")
end

return M
