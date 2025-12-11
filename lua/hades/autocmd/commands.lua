vim.api.nvim_create_user_command("FormatR", function()
	require("hades.utils.r_commands").format()
end, {})
