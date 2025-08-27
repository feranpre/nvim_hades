return {
  "rebelot/kanagawa.nvim", 
  enabled = false,
	config = function()
    require("kanagawa").setup({
        compile=true,
        transparent=true,
    })
    vim.cmd("colorscheme kanagawa")
  end,
  build = function()
    -- for the compile of the colorscheme
    vim.cmd("KanagawaCompile")
  end,
}

