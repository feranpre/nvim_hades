--
-- PERF: Slows down insert mode if open and there are many diagnostics
--
return {
	"folke/trouble.nvim",
	enabled = true,
	config = function()
		local trouble = require("trouble")
		trouble.setup({})
		--
		-- HACK: moved to ~/.config/nvim/lua/hades/config/keybinds_plugins.lua
		--
		-- local function next()
		--   trouble.next({ skip_groups = true, jump = true })
		-- end
		-- local function previous()
		--   trouble.previous({ skip_groups = true, jump = true })
		-- end
		-- vim.keymap.set("n", "]t", next, { desc = "next [t]rouble item" })
		-- vim.keymap.set("n", "[t", previous, { desc = "previous [t]rouble item" })
	end,
}
