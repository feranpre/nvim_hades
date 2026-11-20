return {
	{
		"stevearc/conform.nvim",

		event = {
			"BufWritePre",
		},

		cmd = {
			"ConformInfo",
		},

		-- Los bloques de código de Quarto / R Markdown se localizan con el
		-- parser de markdown de treesitter
		init = function()
			vim.treesitter.language.register("markdown", { "quarto", "rmd" })
		end,

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

				-- Quarto / R Markdown: se formatea cada bloque de código con el
				-- formateador de su lenguaje (R con air/styler, Python con ruff...).
				-- El texto, la cabecera YAML y las opciones #| no se tocan.
				quarto = {
					"injected",
				},

				rmd = {
					"injected",
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

			formatters = {
				injected = {
					options = {
						-- Un bloque con errores no impide formatear los demás
						ignore_errors = true,

						-- Solo bloques de código: ni la cabecera YAML ni el HTML
						lang_to_formatters = {
							yaml = {},
							html = {},
						},
					},
				},
			},

			-- R con styler arranca R y tarda más de 500 ms
			format_on_save = function(bufnr)
				local slow = { r = true, quarto = true, rmd = true }
				return {
					timeout_ms = slow[vim.bo[bufnr].filetype] and 5000 or 500,
					lsp_format = "fallback",
				}
			end,

			notify_on_error = true,
			notify_no_formatters = true,
		},
	},
}
