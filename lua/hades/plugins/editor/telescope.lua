local config = function()
  local telescope = require("telescope")
  -- local actions = require 'telescope.actions'
  local previewers = require("telescope.previewers")
  local new_maker = function(filepath, bufnr, opts)
    opts = opts or {}
    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then
        return
      end
      if stat.size > 100000 then
        return
      else
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end
    end)
  end
  telescope.setup({
    buffer_previewer_maker = new_maker,
    file_ignore_patterns = {
      "node_modules",
      "%_files/*.html",
      "%_cache",
      ".git/",
      "site_libs",
      ".venv",
    },
    layout_strategy = "flex",
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = true,
        hidden = false,
        find_command = {
          "rg",
          "--files",
          "--hidden",
          "--glob",
          "!.git/*",
          "--glob",
          "!**/.Rpro.user/*",
          "--glob",
          "!_site/*",
          "--glob",
          "!docs/**/*.html",
          "-L",
        },
      },
      live_grep = {
        theme = "dropdown",
        previewer = false,
      },
      find_buffers = {
        theme = "dropdown",
        previewer = false,
      },
      keymaps = {
        theme = "dropdown",
        previewer = false,
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown(),
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
    },
  })
end

return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-dap.nvim" },
    {
      "jmbuhr/telescope-zotero.nvim",
      enabled = true,
      dev = false,
      dependencies = {
        { "kkharji/sqlite.lua" },
      },
      config = function()
        vim.keymap.set("n", "<leader>fz", ":Telescope zotero<cr>", { desc = "[z]otero" })
      end,
    },
  },
  config = config,
}
