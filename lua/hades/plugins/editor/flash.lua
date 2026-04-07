return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	keys = {
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "[s]earch (flash)",
		},
		-- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "[S]elect treesitter (flash)" },
		{
			"R",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "[r]emote (flash)",
		},
		-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Search treesitter (flash)" },
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
