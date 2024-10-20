return {
  {
    "R-nvim/R.nvim",
    -- 'jalvesaq/Nvim-R', -- this plugin is obsolete
    enabled = false,
    lazy = false,
    dependencies = {
      "R-nvim/cmp-r",
      -- "nvim-treesitter/nvim-treesitter-textobjects", -- BROKEN
      "hrsh7th/nvim-cmp",
    },
    config = function()
      --   -- Create a table with the options to be passed to setup()
      local opts = {
        -- R_args = { '--quiet', '--no-save' },
        R_args = { "--no-save" },
        -- assign = false, -- convert Meta-- to <-
        auto_quit = true,
        user_maps_only = true,

        Rout_more_colors = true,
        rconsole_width = 40,
        objbr_allnames = true,
        objbr_auto_start = false,
        objbr_h = 10,
        objbr_opendf = false,
        objbr_openlist = false,
        objbr_place = "console,below",

        -- TMUX
        external_term = false,
        -- external_term = "alacritty",
        -- config_tmux = true,

        --   objbr_w = 40,
        -- auto_quit = true,
        -- RStudio_cmd = '/usr/lib/rstudio',
        --   hook = {
        --     after_config = function()
        --       local keymap = require('hades.misc.utils').keymap
        --       local opts = { noremap = true, silent = true, desc = nil }
        --
        --       keymap('n', '<LocalLeader>la', '<cmd>call SendCmndToR('devtools::load_all()')<cr>', opts, '[L]oad all')
        --       -- This function will be called at the FileType event
        --       -- of files supported by R.nvim. This is an
        --       -- opportunity to create mappings local to buffers.
        --       if vim.o.syntax ~= 'rbrowser' then
        --         vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '<Plug>RDSendLine', {})
        --         vim.api.nvim_buf_set_keymap(0, 'v', '<Enter>', '<Plug>RSendSelection', {})
        --       end
        --     end,
        --   },
        --   min_editor_width = 72,
        --   rconsole_width = 78,
        --   disable_cmds = {
        --     'RClearConsole',
        --     'RCustomStart',
        --     'RSPlot',
        --     'RSaveClose',
        --   },
      }
      --   -- Check if the environment variable 'R_AUTO_START' exists.
      --   -- If using fish shell, you could put in your config.fish:
      --   -- alias r 'R_AUTO_START=true nvim'
      -- if vim.env.R_AUTO_START == 'true' then
      --   opts.auto_start = 1
      --   opts.objbr_auto_start = true
      -- end
      require("r").setup(opts)
    end,
  },
}

--
-- -----------------------------------------------------------------
--         R.nvim documentation
-- -----------------------------------------------------------------
--
--
--
--
--
-- 17:14:25 msg_show.echo   RMapsDesc Command
--   RObjectPr             n   ,rp       Send to R: print(<cword>)
--   RClearAll             n   ,rm       Send to R: rm(list   = ls())
--   RSetwd                n   ,rd       Send to R setwd(<directory of current document>)
--   RObjectStr            n   ,rt       Send to R: str(<cword>)
--   RObjectNames          n   ,rn       Send to R: nvim.names(<cword>)
--   RShowArgs             n   ,ra       Send to R: nvim.args(<cword>)
--   RListSpace            n   ,rl       Send to R: ls()
--   RClearConsole         n   ,rr       Send to R: <Ctrl-L>
--   RShowRout             n   ,ao       R CMD BATCH the current document and show the output in a new tab
--   RHelp                 n   ,rh       Ask for R documentation on the object under cursor
--   RSPlot                n   ,rb       Send to R command to run summary and plot with <cword> as argument
--   RPlot                 n   ,rg       Send to R: plot(<cword>)
--   RSummary              n   ,rs       Send to R: summary(<cword>)
-- Send
--   RSendChunk                          Send the current chunk of code to R
--   RSendAboveLines       n   ,su       Send to R all lines above the current one
--   RILeftPart                          Send to R the part of the line on the left of the cursor
--   RNRightPart           n   ,r<Right> Send to R the part of the line on the right of the cursor
--   RNLeftPart            n   ,r<Left>  Send to R the part of the line on the left of the cursor
--   RSendMotion           n   ,m        Send to R the lines in a Vim motion
--   RSendLAndOpenNewOne                 Send the current line and open a new one
--   RInsertLineOutput     n   ,o        Ask R to evaluate the line and insert the output
--   RDSendLine            n   ,d        Send to R the current line and move down to next line
--   RSendLine             n   ,l        Send the current line to R
--   RDSendParagraph       n   ,pd       Send to R the next sequence of consecutive non-empty lines
--   RSendParagraph        n   ,pp       Send to R the next consecutive non-empty lines
--   RDSendSelection       n   ,sd       Send to R visually selected lines or part of a line
--   RSendSelection        n   ,ss       Send visually selected lines of part of a line
--   RSendChain            n   ,sc       Send to R the above chain of piped commands
--   RDSendCurrentFun      n   ,fd       Send the current function and move the cursor to the end of the function definition
--   RSendCurrentFun       n   ,fc       Send the current function
--   RDSendMBlock          n   ,bd       Send to R the lines between two marks and move to next line
--   RSendMBlock           n   ,bb       Send to R the lines between two marks
--   RSendChunkFH                        Send all chunks of R code from the document's begin up to here
--   RSendAllFun           n   ,fa       Send all the top level functions in the current buffer
--   RIRightPart                         Send to R the part of the line on the right of the cursor
--   RSendFile             n   ,aa       Send the whole file to R
--   RDSendChunk                         Send to R the current chunk of R code and move down to next chunk
-- Navigate
--   RDocExSection                       Go to Examples section of R documentation
--   RGoToTeX                            Go the corresponding line in the generated LaTeX document
--   RSyncFor                            SyncTeX forward (move from Rnoweb to the corresponding line in the PDF)
--   RPreviousRChunk                     Go to the previous chunk of R code
--   RNextRChunk                         Go to the next chunk of R code
-- Edit
--   RViewDFa              n   ,vh       View the head of a data.frame or matrix under cursor in a split window
--   RViewDFv              n   ,vv       View the data.frame or matrix under cursor in a vertically split window
--   RViewDFs              n   ,vs       View the data.frame or matrix under cursor in a split window
--   RAssign               i   <M-->     Replace `config.assign_map` with ` <- `
--   RDputObj              n   ,td       Run dput(<cword>) and show the output in a new tab
--   RViewDF               n   ,rv       View the data.frame or matrix under cursor in a new tab
--   ROpenPDF                            Open the PDF generated from the current document
--   RShowEx               n   ,re       Extract the Examples section and paste it in a split window
-- Start
--   RSaveClose            n   ,rw       Quit R, saving the workspace
--   RClose                n   ,rq       Send to R: quit(save = 'no')
--   RCustomStart          n   ,rc       Ask user to enter parameters to start R
--   RStart                n   ,rf       Start R with default configuration or reopen terminal window
-- Object_Browser
--   ROBToggle             n   ,ro       Toggle the Object Browser
--   ROBCloseLists         n   ,r-       Close S4 objects, lists and data.frames in the Object Browser
--   ROBOpenLists          n   ,r=       Open S4 objects, lists and data.frames in the Object Browser
-- Weave
--   RKnit                               Knit the document
--   RMakeHTML             n   ,kh       Knit the current document and generate an HTML document
--   RBibTeXK                            Knit the document, run bibtex and generate the PDF
--   RBibTeX                             Sweave the document and run bibtex
--   RMakePDF                            Sweave the current document and generate a PDF document
--   RSweave                             Sweave the current document
--   RQuartoStop                         Send to R: quarto::quarto_preview_stop()
--   RMakePDFKb            n   ,kl       Knit the current document and generate a beamer presentation
--   RMakePDFK             n   ,kp       Knit the current document and generate a PDF document
--   RMakeAll              n   ,ka       Knit the current document and generate all formats in the header
--   RMakeRmd              n   ,kr       Knit the current document and generate the default document format
--   RMakeWord             n   ,kw       Knit the current document and generate a Word document
--   RMakeODT              n   ,ko       Knit the current document and generate an ODT document
--   RQuartoPreview                      Send to R: quarto::quarto_preview()
--   RQuartoRender                       Send to R: quarto::quarto_render()
--   RKnitRmCache                        Delete files from knitr cache

--  OPTIONS

-- {
--   OutDec = '.',
--   RStudio_cmd = '',
--   R_app = 'R',
--   R_args = {},
--   R_cmd = 'R',
--   R_path = '',
--   Rout_more_colors = false,
--   active_window_warn = true,
--   applescript = false,
--   arrange_windows = false,
--   assign = true,
--   assign_map = '<M-->',
--   auto_quit = true,
--   auto_scroll = true,
--   auto_start = 'no',
--   bracketed_paste = false,
--   buffer_opts = 'winfixwidth winfixheight nobuflisted',
--   clear_console = true,
--   clear_line = false,
--   close_term = true,
--   compldir = '/home/fandresp/.cache/R.nvim',
--   config_tmux = true,
--   csv_app = '',
--   curview = 'None',
--   disable_cmds = { '' },
--   editing_mode = 'emacs',
--   esc_term = true,
--   external_term = false,
--   has_X_tools = false,
--   help_w = 46,
--   hl_term = true,
--   hook = {},
--   insert_mode_cmds = false,
--   is_darwin = false,
--   is_windows = false,
--   latexcmd = { 'default' },
--   listmethods = false,
--   local_R_library_dir = '',
--   localtmpdir = '/dev/shm/R.nvim-fandresp',
--   max_paste_lines = 20,
--   min_editor_width = 80,
--   non_r_compl = true,
--   nvimpager = 'split',
--   objbr_allnames = false,
--   objbr_auto_start = false,
--   objbr_h = 10,
--   objbr_opendf = true,
--   objbr_openlist = false,
--   objbr_place = 'script,right',
--   objbr_w = 40,
--   open_example = true,
--   open_html = 'open and focus',
--   open_pdf = 'open and focus',
--   paragraph_begin = true,
--   parenblock = true,
--   pdfviewer = 'zathura',
--   quarto_preview_args = '',
--   quarto_render_args = '',
--   rconsole_height = 15,
--   rconsole_width = 40,
--   remote_compldir = '',
--   rm_knit_cache = false,
--   rmarkdown_args = '',
--   rmd_environment = '.GlobalEnv',
--   rmdchunk = 2,
--   rmhidden = false,
--   rnowebchunk = true,
--   rnvim_home = '/home/fandresp/.local/share/nvim/lazy/R.nvim',
--   routnotab = false,
--   save_win_pos = false,
--   set_home_env = true,
--   setwd = 'no',
--   setwidth = 2,
--   silent_term = false,
--   skim_app_path = '',
--   source_args = '',
--   source_read = '/dev/shm/R.nvim-fandresp/Rsource-13820',
--   source_write = '/dev/shm/R.nvim-fandresp/Rsource-13820',
--   specialplot = false,
--   synctex = true,
--   term_pid = 0,
--   term_title = 'term',
--   texerr = true,
--   tmpdir = '/dev/shm/R.nvim-fandresp',
--   uname = 'Linux',
--   user_login = 'fandresp',
--   user_maps_only = false,
--   uservimfiles = '/home/fandresp/.local/share/nvim/lazy/R.nvim',
--   wait = 60
-- }
