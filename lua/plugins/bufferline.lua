return {
	{
		"akinsho/bufferline.nvim",

		event = "VeryLazy",

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		opts = {
			options = {
				mode = "buffers",

				numbers = "ordinal",

				close_command = "bdelete! %d",
				right_mouse_command = "bdelete! %d",

				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,

				separator_style = "slant",

				show_buffer_close_icons = true,
				show_close_icon = false,

				show_buffer_icons = true,
				show_buffer_default_icon = true,

				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,

				always_show_bufferline = true,

				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},

				sort_by = "id",

				custom_areas = {
					left = function()
						local buffers = vim.fn.getbufinfo({
							buflisted = 1,
						})

						return {
							{
								" 󰈚 " .. #buffers .. " ",
								"BufferLineIndicatorSelected",
							},
						}
					end,
				},
			},

			highlights = {},
		},

		config = function(_, opts)
			require("bufferline").setup(opts)

			-- Actualizar el contador cuando cambie el número de buffers.
			vim.api.nvim_create_autocmd({
				"BufAdd",
				"BufDelete",
				"BufWipeout",
			}, {
				callback = function()
					vim.schedule(function()
						vim.cmd("redrawtabline")
					end)
				end,
			})
		end,
	},
}
