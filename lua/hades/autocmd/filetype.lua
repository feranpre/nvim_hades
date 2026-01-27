vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
	desc = "HADES file binds for r",
	pattern = { "r", "rmd", "markdown", "quarto" },
	callback = function(ev)
		-- require("hades.config.keybinds.markdown").load_keys(ev)
		require("hades.config.keybinds_plugins.r").load_keys(ev)
		-- require("hades.config.keybinds_molten").load_keys(ev)
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
	desc = "HADES file binds for r",
	pattern = { "python" },
	callback = function(ev)
		-- require("hades.config.keybinds.markdown").load_keys(ev)
		require("hades.config.keybinds_plugins.r").load_keys(ev)
		-- require("hades.config.keybinds_molten").load_keys(ev)
	end,
})
