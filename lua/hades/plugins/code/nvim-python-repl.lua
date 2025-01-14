return {
  {
    "geg2102/nvim-python-repl",
    enabled = false,
    dependencies = "nvim-treesitter",
    ft = { "python", "lua", "scala" },
    config = function()
      require("nvim-python-repl").setup({
        execute_on_send = true,
        vsplit = true,
        prompt_spawn = false,
        spawn_command = {
          python = "ipython",
        },
      })
    end,
  },
}
