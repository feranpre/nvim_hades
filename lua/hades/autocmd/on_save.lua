local r_utils = require("hades.utils.r_commands")

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.R", "*.r", "*.Rmd", "*.qmd" },
	callback = function()
		r_utils.format()
	end,
})
