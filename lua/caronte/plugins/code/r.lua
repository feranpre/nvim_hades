return {
  "R-nvim/R.nvim",
  -- "jalvesaq/Nvim-R", -- this plugin is obsolete
  enabled = false,
  lazy = false,
  dependencies = {
    "R-nvim/cmp-r",
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("cmp").setup({ sources = { { name = "cmp_r" } } })
        require("cmp_r").setup({})
      end,
    },
  },
  config = function()
    -- Create a table with the options to be passed to setup()
    local opts = {
      R_args = { "--quiet", "--no-save" },
      hook = {
        after_config = function()
          -- This function will be called at the FileType event
          -- of files supported by R.nvim. This is an
          -- opportunity to create mappings local to buffers.
          if vim.o.syntax ~= "rbrowser" then
            local keymap = require("caronte.misc.utils").keymap
            local opts = { noremap = true, silent = true, desc = nil }

            keymap("n", "<LocalLeader>la", "<cmd>call SendCmndToR('devtools::load_all()')<cr>", opts, "[L]oad all")
            vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
            vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
          end
        end,
      },
      min_editor_width = 72,
      rconsole_width = 78,
      disable_cmds = {
        "RClearConsole",
        "RCustomStart",
        "RSPlot",
        "RSaveClose",
      },
    }
    -- Check if the environment variable "R_AUTO_START" exists.
    -- If using fish shell, you could put in your config.fish:
    -- alias r "R_AUTO_START=true nvim"
    if vim.env.R_AUTO_START == "true" then
      opts.auto_start = 1
      opts.objbr_auto_start = true
    end
    require("r").setup(opts)
  end,
}
