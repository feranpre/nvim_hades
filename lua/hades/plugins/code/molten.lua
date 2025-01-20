return {
  {
    "benlubas/molten-nvim",
    enabled = false,
    dev = false,
    -- version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_open_cmd = "firefox"
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20

      -- local function molten_venv_select()
      --   local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
      --   if venv ~= nil then
      --     -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
      --     venv = string.match(venv, "/.+/(.+)")
      --     vim.cmd(("MoltenInit %s"):format(venv))
      --   else
      --     vim.cmd("MoltenInit python3")
      --   end
      -- end
      -- molten_venv_select()
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    "3rd/image.nvim",
    enabled = true,
    opts = {
      backend = "ueberzug", -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
