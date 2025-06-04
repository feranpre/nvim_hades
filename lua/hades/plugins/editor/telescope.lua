return {
  'nvim-telescope/telescope.nvim',
  -- tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    },
    {
      'jmbuhr/telescope-zotero.nvim',
      dependencies = {
        { 'kkharji/sqlite.lua' },
      },
      -- options:
      -- to use the default opts:
      -- opts = {},
      -- to configure manually:
      config = function()
        require('zotero').setup()
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      pickers = {
        find_files = {
          theme = "ivy"
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
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        }
      },
    })

    telescope.load_extension('fzf')
    telescope.load_extension("zotero")
  end,
}
