return {
	{
		"quarto-dev/quarto-nvim",

		ft = {
			"quarto",
			"markdown",
			"rmd",
		},

		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
		},

		opts = {
			debug = false,

			closePreviewOnExit = true,

			lspFeatures = {
				enabled = true,

				chunks = "curly",

				languages = {
					"r",
					"python",
					"julia",
					"bash",
					"html",
				},

				diagnostics = {
					enabled = true,
					triggers = {
						"BufWritePost",
					},
				},

				completion = {
					enabled = true,
				},
			},

			codeRunner = {
				enabled = true,

				default_method = "iron",

				ft_runners = {},
			},
		},
	},
}
