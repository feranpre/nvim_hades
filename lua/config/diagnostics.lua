vim.diagnostic.config({
	underline = true,

	signs = true,

	virtual_text = {
		spacing = 2,
		source = "if_many",
	},

	severity_sort = true,

	float = {
		border = "rounded",
		source = "if_many",
	},

	update_in_insert = false,
})
