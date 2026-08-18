return {
	{
		"Vigemus/iron.nvim",

		config = function()
			local iron = require("iron.core")

			iron.setup({
				config = {
					scratch_repl = true,

					repl_definition = {
						r = {
							command = {
								"R",
								"--quiet",
								"--no-save",
							},
						},

						python = {
							command = {
								"ipython",
							},
						},
					},

					repl_open_cmd = require("iron.view").split.vertical.botright(0.4),
				},

				keymaps = {},

				highlight = {
					italic = true,
				},

				ignore_blank_lines = true,
			})
		end,
	},
}
