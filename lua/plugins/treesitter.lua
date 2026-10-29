-- nvim-treesitter tiene dos ramas incompatibles entre sí:
--   main   -> Neovim >= 0.12 y `tree-sitter-cli` instalado (API nueva)
--   master -> Neovim 0.10 / 0.11 (API clásica, congelada pero mantenida)
-- Se elige la rama según la versión de Neovim para que la misma
-- configuración funcione en todos los equipos.
local modern = vim.fn.has("nvim-0.12") == 1
local branch = modern and "main" or "master"

local parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"csv",
	"html",
	"javascript",
	"json",
	"latex",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"r",
	"rnoweb",
	"regex",
	"toml",
	"typst",
	"vim",
	"vimdoc",
	"yaml",
}

local textobjects = {
	["af"] = { query = "@function.outer", desc = "[a]round [f]unction" },
	["if"] = { query = "@function.inner", desc = "[i]nside [f]unction" },
	["ac"] = { query = "@class.outer", desc = "[a]round [c]lass" },
	["ic"] = { query = "@class.inner", desc = "[i]nside [c]lass" },
}

local function setup_main()
	if vim.fn.executable("tree-sitter") == 1 then
		require("nvim-treesitter").install(parsers)
	else
		vim.notify(
			"nvim-treesitter: falta `tree-sitter-cli` (p. ej. `sudo pacman -S tree-sitter-cli`); no se pueden instalar parsers",
			vim.log.levels.WARN
		)
	end

	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local ok = pcall(vim.treesitter.start, args.buf)

			if not ok then
				return
			end

			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

local function setup_master()
	local keymaps = {}

	for lhs, obj in pairs(textobjects) do
		keymaps[lhs] = { query = obj.query, desc = obj.desc }
	end

	-- En master, latex necesita tree-sitter-cli para compilarse: se omite
	local ensure = vim.tbl_filter(function(lang)
		return lang ~= "latex"
	end, parsers)

	require("nvim-treesitter.configs").setup({
		ensure_installed = ensure,
		highlight = { enable = true },
		indent = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = keymaps,
			},
		},
	})
end

return {
	{
		"nvim-treesitter/nvim-treesitter",

		branch = branch,

		lazy = false,

		build = ":TSUpdate",

		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},

		config = modern and setup_main or setup_master,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",

		branch = branch,

		-- En la rama master los textobjects se configuran desde
		-- nvim-treesitter.configs (arriba)
		config = function()
			if not modern then
				return
			end

			local select = require("nvim-treesitter-textobjects.select")

			for lhs, obj in pairs(textobjects) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(obj.query)
				end, { desc = obj.desc })
			end
		end,
	},
}
