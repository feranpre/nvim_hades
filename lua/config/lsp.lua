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
end

return M
