return {
	"jakewvincent/mkdnflow.nvim",
	enabled = false,
	ft = { "markdown", "quarto" },
	config = function()
		require("mkdnflow").setup({
			modules = {
				bib = true,
				buffers = true,
				conceal = true,
				links = true,
				lists = true,
				maps = true,
				yaml = true,
			},

			filetypes = {
				markdown = true,
				quarto = true,
			},

			mappings = {
				MkdnEnter = { { "i", "n", "v" }, "<CR>" },
			},
		})
	end,
}

-- return {
-- 	"jakewvincent/mkdnflow.nvim",
-- 	ft = { "markdown", "quarto" },
-- 	config = function()
-- 		require("mkdnflow").setup({
-- 			modules = {
-- 				bib = true,
-- 				buffers = true,
-- 				conceal = true,
-- 				links = true,
-- 				lists = true,
-- 				maps = true,
-- 				yaml = true,
-- 			},
-- 			filetypes = { markdown = true, quarto = true },
-- 			mappings = {
-- 				MkdnEnter = { { "i", "n", "v" }, "<CR>" }, -- This monolithic command has the aforementioned
-- 				-- insert-mode-specific behavior and also will trigger row jumping in tables. Outside
-- 				-- of lists and tables, it behaves as <CR> normally does.
-- 				-- MkdnNewListItem = {'i', '<CR>'} -- Use this command instead if you only want <CR> in
-- 				-- insert mode to add a new list item (and behave as usual outside of lists).
-- 			},
-- 		})
-- 	end,
-- }
