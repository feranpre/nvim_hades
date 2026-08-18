-- ~/.config/nvim/init.lua

require("config.options")
require("config.autocmds")
-- require("config.commands")
require("config.diagnostics")
require("config.theme")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"

	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{
				"Failed to clone lazy.nvim:\n",
				"ErrorMsg",
			},
			{
				out,
				"WarningMsg",
			},
		}, true, {})

		return
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},

	checker = {
		enabled = true,
		notify = false,
	},
})

require("config.lsp").setup()
require("config.folding").setup()

require("config.keymaps")
