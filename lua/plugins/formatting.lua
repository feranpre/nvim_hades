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

				-- air: formateador de R de Posit, muy rápido (https://posit-dev.github.io/air/).
				-- Si no está instalado, conform lo ignora. Para formatear con styler
				-- en lugar de air: ,bs
				r = {
					"air",
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

			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},

			notify_on_error = true,
			notify_no_formatters = true,
		},
	},
}
