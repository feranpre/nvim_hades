local r_utils = require("hades.utils.r_commands")

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.R", "*.r", "*.Rmd", "*.qmd" },
	callback = function()
		r_utils.format()
	end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.py",
	callback = function(args)
		local ipynb = args.file:gsub("%.py$", ".ipynb")

		if vim.fn.filereadable(ipynb) == 1 then
			vim.system({ "jupytext", "--sync", args.file }, { detach = true })
		end
	end,
})
