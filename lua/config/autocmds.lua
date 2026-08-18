--
-- ~/.config/nvim/lua/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup

local general = augroup("General", {
	clear = true,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = general,

	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Remove trailing whitespace before saving
vim.api.nvim_create_autocmd("BufWritePre", {
	group = general,
	pattern = "*",

	callback = function()
		local view = vim.fn.winsaveview()

		vim.cmd([[%s/\s\+$//e]])

		vim.fn.winrestview(view)
	end,
})

---------------------------------------------------------------------------
-- Filetype-specific configuration
---------------------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
	group = general,

	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype

		-- Generic folding keymaps
		require("config.keymaps.folding").setup(buf)

		-- Markdown-style section folding
		if ft == "markdown" or ft == "quarto" or ft == "rmd" then
			require("config.utils.markdown_folding").setup()
		end

		-- R
		if ft == "r" then
			require("config.keymaps.r").setup(buf)

		-- Quarto / R Markdown
		elseif ft == "quarto" or ft == "rmd" then
			require("config.keymaps.quarto").setup(buf)

		-- Markdown
		elseif ft == "markdown" then
			require("config.keymaps.markdown").setup(buf)
		end
	end,
})
