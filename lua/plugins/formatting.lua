return {
	{
		"stevearc/conform.nvim",

		event = {
			"BufWritePre",
		},

		cmd = {
			"ConformInfo",
		},

		opts = {
			formatters_by_ft = {
				lua = {
					"stylua",
				},

				python = {
					"ruff_format",
				},

				javascript = {
					"prettier",
				},

				typescript = {
					"prettier",
				},

				json = {
					"prettier",
				},

				yaml = {
					"prettier",
				},

				html = {
					"prettier",
				},

				css = {
					"prettier",
				},

				markdown = {
					"prettier",
				},

				-- air: formateador de R de Posit, muy rápido (https://posit-dev.github.io/air/),
				-- lo instala Mason. Si no estuviera, se usa styler (paquete de R).
				-- Para formatear con styler en lugar de air: ,bs
				r = {
					"air",
					"styler",
					stop_after_first = true,
				},

				sh = {
					"shfmt",
				},

				bash = {
					"shfmt",
				},
			},

			default_format_opts = {
				lsp_format = "fallback",
			},

			-- R con styler arranca R y tarda más de 500 ms
			format_on_save = function(bufnr)
				return {
					timeout_ms = vim.bo[bufnr].filetype == "r" and 5000 or 500,
					lsp_format = "fallback",
				}
			end,

			notify_on_error = true,
			notify_no_formatters = true,
		},
	},
}
