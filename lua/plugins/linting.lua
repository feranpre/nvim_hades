-- lintr (R): nvim-lint no lo trae, se define aquí. Respeta el .lintr del
-- proyecto (lo busca en la carpeta del archivo y sus padres; ,Pc lo crea).
local function lintr_linter()
	local severity = vim.diagnostic.severity

	local r_code = table.concat({
		"for (f in commandArgs(TRUE)) for (l in lintr::lint(f))",
		"cat(sprintf('%d:%d:%s:%s [%s]\\n', l$line_number, l$column_number,",
		"l$type, gsub('\\n', ' ', l$message), l$linter))",
	}, " ")

	return {
		cmd = "Rscript",
		stdin = false,
		append_fname = true,
		args = { "--no-save", "--no-restore", "-e", r_code },
		ignore_exitcode = true,
		stream = "stdout",
		parser = require("lint.parser").from_pattern(
			"^(%d+):(%d+):(%w+):(.*)$",
			{ "lnum", "col", "severity", "message" },
			{
				error = severity.ERROR,
				warning = severity.WARN,
				style = severity.INFO,
			},
			{ source = "lintr" }
		),
	}
end

-- Linters lentos (arrancan R): solo al guardar, no al salir de inserción
local SLOW = {
	r = true,
}

return {
	{
		"mfussenegger/nvim-lint",

		event = {
			"BufReadPost",
			"BufNewFile",
		},

		config = function()
			local lint = require("lint")

			lint.linters.lintr = lintr_linter()

			lint.linters_by_ft = {
				python = {
					"ruff",
				},

				lua = {
					"luacheck",
				},

				sh = {
					"shellcheck",
				},

				bash = {
					"shellcheck",
				},

				markdown = {
					"markdownlint",
				},

				yaml = {
					"yamllint",
				},
			}

			-- lintr solo si R y el paquete están instalados (se comprueba una vez)
			if vim.fn.executable("Rscript") == 1 then
				vim.system(
					{ "Rscript", "-e", "quit(status = as.integer(!requireNamespace('lintr', quietly = TRUE)))" },
					{},
					function(result)
						if result.code == 0 then
							vim.schedule(function()
								lint.linters_by_ft.r = { "lintr" }
							end)
						end
					end
				)
			end

			vim.api.nvim_create_autocmd({
				"BufWritePost",
				-- "BufEnter",
				"InsertLeave",
			}, {
				callback = function(args)
					if args.event == "InsertLeave" and SLOW[vim.bo[args.buf].filetype] then
						return
					end

					lint.try_lint()
				end,
			})
		end,
	},
}
