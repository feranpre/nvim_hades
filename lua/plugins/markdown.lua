return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = true,

		ft = {
			"markdown",
			"quarto",
			"rmd",
		},

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},

		opts = {
			heading = {
				enabled = true,
			},

			code = {
				enabled = true,
				style = "full",
			},

			pipe_table = {
				enabled = true,
				style = "full",
			},

			latex = {
				enabled = true,
			},

			bullet = {
				enabled = true,
			},

			checkbox = {
				enabled = true,
			},
		},
	},
}
