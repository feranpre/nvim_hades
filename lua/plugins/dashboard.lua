-- Portada al abrir Neovim sin archivos
return {
	{
		"folke/snacks.nvim",

		lazy = false,

		priority = 1000,

		opts = {
			dashboard = {
				enabled = true,

				preset = {
					-- Rótulo generado con figlet (fuente "ANSI Shadow")
					header = [[
██╗  ██╗ █████╗ ██████╗ ███████╗███████╗     ██████╗     █████╗ 
██║  ██║██╔══██╗██╔══██╗██╔════╝██╔════╝    ██╔═████╗   ██╔══██╗
███████║███████║██║  ██║█████╗  ███████╗    ██║██╔██║   ╚█████╔╝
██╔══██║██╔══██║██║  ██║██╔══╝  ╚════██║    ████╔╝██║   ██╔══██╗
██║  ██║██║  ██║██████╔╝███████╗███████║    ╚██████╔╝██╗╚█████╔╝
╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝     ╚═════╝ ╚═╝ ╚════╝ 
]],

					keys = {
						{ icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
						{ icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
						{ icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
						{ icon = " ", key = "g", desc = "Grep text", action = ":Telescope live_grep" },
						{
							icon = "󰐨 ",
							key = "s",
							desc = "New presentation",
							action = function()
								require("config.utils.slides").new()
							end,
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = function()
								require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
							end,
						},
						{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},

				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
	},
}
