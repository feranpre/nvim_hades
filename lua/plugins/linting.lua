return {
	{
		"mfussenegger/nvim-lint",

		event = {
			"BufReadPost",
			"BufNewFile",
		},

		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = {
					"ruff",
				},

				lua = {
					"luacheck",
				},

				sh = {
					"shellcheck",
				},

				bash = {
					"shellcheck",
				},

				markdown = {
					"markdownlint",
				},

				yaml = {
					"yamllint",
				},
			}

			vim.api.nvim_create_autocmd({
				"BufWritePost",
				-- "BufEnter",
				"InsertLeave",
			}, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
