return {
	{
		"nvim-treesitter/nvim-treesitter",

		branch = "main",

		lazy = false,

		build = ":TSUpdate",

		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},

		config = function()
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

			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ok = pcall(vim.treesitter.start, args.buf)

					if not ok then
						return
					end

					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",

		branch = "main",

		event = "VeryLazy",

		config = function()
			local select = require("nvim-treesitter-textobjects.select")

			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer")
			end, {
				desc = "[a]round [f]unction",
			})

			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner")
			end, {
				desc = "[i]nside [f]unction",
			})

			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer")
			end, {
				desc = "[a]round [c]lass",
			})

			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner")
			end, {
				desc = "[i]nside [c]lass",
			})
		end,
	},
}
