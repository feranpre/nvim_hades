local map = vim.keymap.set

map("n", "<leader>lf", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, {
	desc = "[f]ormat buffer",
})

map("v", "<leader>lf", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, {
	desc = "[f]ormat selection",
})
