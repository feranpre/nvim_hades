return {
	{
		"nvim-lualine/lualine.nvim",

		event = "VeryLazy",

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		opts = {
			options = {
				theme = "dracula",

				globalstatus = true,

				section_separators = {
					left = "",
					right = "",
				},

				component_separators = {
					left = "",
					right = "",
				},
			},

			sections = {
				lualine_a = {
					"mode",
				},

				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
				},

				lualine_c = {
					{
						"filename",

						path = 1,

						symbols = {
							modified = " ●",
							readonly = " ",
							unnamed = "[No Name]",
						},
					},
				},

				lualine_x = {
					"filetype",
					"encoding",
					"fileformat",
				},

				lualine_y = {
					"progress",
				},

				lualine_z = {
					"location",
				},
			},
		},
	},
}
