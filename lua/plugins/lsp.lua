return {
	{
		"neovim/nvim-lspconfig",

		lazy = false,
	},

	{
		"mason-org/mason.nvim",

		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUpdate",
		},

		opts = {},
	},

	{
		"mason-org/mason-lspconfig.nvim",

		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},

		opts = {
			ensure_installed = {
				"lua_ls",
				"pyright",
				"bashls",
				"jsonls",
				"yamlls",
			},

			automatic_enable = true,
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		dependencies = {
			"mason-org/mason.nvim",
		},

		opts = {
			ensure_installed = {
				-- Formatters
				"stylua",
				"ruff",
				"prettier",
				"shfmt",

				-- Linters
				"luacheck",
				"shellcheck",
				"markdownlint",
				"yamllint",
			},

			auto_update = false,
			run_on_start = true,
		},
	},
}
