return {
	{
		"Vigemus/iron.nvim",
		cmd = { "IronRepl", "IronRestart", "IronFocus" },
		keys = {
			{ "<C-CR>", mode = { "n", "v" } },
			{ "<C-S-CR>", mode = "n" },
			{ "<leader>rc", mode = "n", desc = "Run chunk" },
		},
		config = function()
			local iron = require("iron.core")

			iron.setup({
				config = {
					scratch_repl = false,
					repl_definition = {
						python = {
							command = { "python3" },
						},
					},
					repl_open_cmd = "vertical botright 60 split",
				},
				keymaps = {
					send_line = "<C-CR>",
					send_visual = "<C-CR>",
					send_file = "<C-S-CR>",
				},
			})

			-- 🔖 Definición de chunks tipo Jupyter
			vim.g.iron_markers = {
				python = { "# %%" },
			}

			-- ▶ Ejecutar chunk actual
			vim.keymap.set("n", "<leader>rc", function()
				require("iron.core").send_mark()
			end, { desc = "Run Python chunk" })

			-- 🚀 Abrir REPL automáticamente al entrar en Python
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function()
					iron.repl_for("python")
				end,
			})
		end,
	},
}
