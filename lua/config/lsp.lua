local M = {}

function M.setup()
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},

				diagnostics = {
					globals = {
						"vim",
					},
				},

				workspace = {
					checkThirdParty = false,
				},

				telemetry = {
					enable = false,
				},
			},
		},
	})

	vim.lsp.config("pyright", {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
	})

	M.setup_r()
end

-- R: languageserver (paquete de R, no de Mason). Da ir a definición,
-- referencias, hover, símbolos, renombrar... El autocompletado ya lo da
-- R.nvim y los avisos los da lintr con nvim-lint, así que aquí se apagan
-- para no verlos duplicados.
function M.setup_r()
	vim.lsp.config("r_language_server", {
		filetypes = { "r", "rmd", "quarto" },

		settings = {
			r = {
				lsp = {
					diagnostics = false,
					rich_documentation = true,
				},
			},
		},

		on_init = function(client)
			client.server_capabilities.completionProvider = nil
		end,
	})

	if vim.fn.executable("R") == 0 then
		return
	end

	-- Solo si el paquete está instalado; si no, se avisa una vez
	vim.system(
		{ "Rscript", "-e", "quit(status = as.integer(!requireNamespace('languageserver', quietly = TRUE)))" },
		{},
		function(result)
			vim.schedule(function()
				if result.code == 0 then
					vim.lsp.enable("r_language_server")
				else
					vim.notify(
						"LSP de R: falta el paquete languageserver.\n"
							.. "Instálalo en R con install.packages(\"languageserver\") y reinicia Neovim.",
						vim.log.levels.WARN
					)
				end
			end)
		end
	)
end

return M
