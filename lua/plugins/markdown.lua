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

	{
		"jakewvincent/mkdnflow.nvim",

		ft = {
			"markdown",
		},

		opts = {
			filetypes = {
				markdown = true,
				rmd = false,
			},

			modules = {
				-- El plegado lo lleva config.utils.markdown_folding
				folds = false,
				foldtext = false,
				bib = false,
				backlinks = false,
			},

			links = {
				-- Al crear un enlace desde una palabra no añadir la fecha
				transform_on_create = function(text)
					return text:gsub("[ /]", "-"):lower()
				end,
			},

			-- Los mapeos con <leader> se mueven a <localleader>m / <localleader>t
			-- (ver config.keymaps.markdown)
			mappings = {
				-- En insert: continuar la lista (un item vacío la termina)
				MkdnNewListItem = { "i", "<CR>" },
				MkdnUpdateNumbering = false,
				MkdnTableNewRowBelow = false,
				MkdnTableNewRowAbove = false,
				MkdnTableNewColAfter = false,
				MkdnTableNewColBefore = false,
				MkdnTableDeleteRow = false,
				MkdnTableDeleteCol = false,
				MkdnTableAlignLeft = false,
				MkdnTableAlignRight = false,
				MkdnTableAlignCenter = false,
				MkdnTableAlignDefault = false,
				MkdnFoldSection = false,
				MkdnUnfoldSection = false,
				MkdnCreateLinkFromClipboard = false,
				-- <C-Space> es de blink.cmp
				MkdnToggleToDo = false,
			},
		},
	},
}
