-- {
--   OutDec = ".",
--   RStudio_cmd = "",
--   R_app = "R",
--   R_args = {},
--   R_cmd = "R",
--   R_path = "",
--   Rout_more_colors = false,
--   active_window_warn = true,
--   applescript = false,
--   arrange_windows = false,
--   assign = true,
--   assign_map = "<M-->",
--   auto_quit = true,
--   auto_scroll = true,
--   auto_start = "no",
--   bracketed_paste = false,
--   buffer_opts = "winfixwidth winfixheight nobuflisted",
--   clear_console = true,
--   clear_line = false,
--   close_term = true,
--   compldir = "/home/fandresp/.cache/R.nvim",
--   config_tmux = true,
--   csv_app = "",
--   curview = "None",
--   disable_cmds = { "" },
--   editing_mode = "emacs",
--   esc_term = true,
--   external_term = false,
--   has_X_tools = false,
--   help_w = 46,
--   hl_term = true,
--   hook = {},
--   insert_mode_cmds = false,
--   is_darwin = false,
--   is_windows = false,
--   latexcmd = { "default" },
--   listmethods = false,
--   local_R_library_dir = "",
--   localtmpdir = "/dev/shm/R.nvim-fandresp",
--   max_paste_lines = 20,
--   min_editor_width = 80,
--   non_r_compl = true,
--   nvimpager = "split",
--   objbr_allnames = false,
--   objbr_auto_start = false,
--   objbr_h = 10,
--   objbr_opendf = true,
--   objbr_openlist = false,
--   objbr_place = "script,right",
--   objbr_w = 40,
--   open_example = true,
--   open_html = "open and focus",
--   open_pdf = "open and focus",
--   paragraph_begin = true,
--   parenblock = true,
--   pdfviewer = "zathura",
--   quarto_preview_args = "",
--   quarto_render_args = "",
--   rconsole_height = 15,
--   rconsole_width = 80,
--   remote_compldir = "",
--   rm_knit_cache = false,
--   rmarkdown_args = "",
--   rmd_environment = ".GlobalEnv",
--   rmdchunk = 2,
--   rmhidden = false,
--   rnowebchunk = true,
--   rnvim_home = "/home/fandresp/.local/share/nvim/lazy/R.nvim",
--   routnotab = false,
--   save_win_pos = false,
--   set_home_env = true,
--   setwd = "no",
--   setwidth = 2,
--   silent_term = false,
--   skim_app_path = "",
--   source_args = "",
--   source_read = "/dev/shm/R.nvim-fandresp/Rsource-13820",
--   source_write = "/dev/shm/R.nvim-fandresp/Rsource-13820",
--   specialplot = false,
--   synctex = true,
--   term_pid = 0,
--   term_title = "term",
--   texerr = true,
--   tmpdir = "/dev/shm/R.nvim-fandresp",
--   uname = "Linux",
--   user_login = "fandresp",
--   user_maps_only = false,
--   uservimfiles = "/home/fandresp/.local/share/nvim/lazy/R.nvim",
--   wait = 60
-- }

return {
  "R-nvim/R.nvim",
  -- "jalvesaq/Nvim-R", -- this plugin is obsolete
  enabled = true,
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
    --   -- Create a table with the options to be passed to setup()
    local opts = {
      -- R_args = { "--quiet", "--no-save" },
      R_args = { "--no-save" },
      -- auto_quit = true,
      -- RStudio_cmd = "/usr/lib/rstudio",
      --   hook = {
      --     after_config = function()
      --       local keymap = require("hades.misc.utils").keymap
      --       local opts = { noremap = true, silent = true, desc = nil }
      --
      --       keymap("n", "<LocalLeader>la", "<cmd>call SendCmndToR('devtools::load_all()')<cr>", opts, "[L]oad all")
      --       -- This function will be called at the FileType event
      --       -- of files supported by R.nvim. This is an
      --       -- opportunity to create mappings local to buffers.
      --       if vim.o.syntax ~= "rbrowser" then
      --         vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
      --         vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
      --       end
      --     end,
      --   },
      --   min_editor_width = 72,
      --   rconsole_width = 78,
      --   disable_cmds = {
      --     "RClearConsole",
      --     "RCustomStart",
      --     "RSPlot",
      --     "RSaveClose",
      --   },
    }
    --   -- Check if the environment variable "R_AUTO_START" exists.
    --   -- If using fish shell, you could put in your config.fish:
    --   -- alias r "R_AUTO_START=true nvim"
    -- if vim.env.R_AUTO_START == "true" then
    --   opts.auto_start = 1
    --   opts.objbr_auto_start = true
    -- end
    require("r").setup(opts)
  end,
}
