vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
  desc = "r file binds",
  -- pattern = { "r", "quarto" },
  pattern = { "r" },
  callback = function(ev)
    local opts = { noremap = true, silent = true, desc = nil }
    local keymap_buffer = require("hades.misc.utils").keymap_buffer
    local key_or_clue = require("hades.misc.utils").key_or_clue
    local isModuleAvailable = require("hades.misc.utils").isModuleAvailable

    key_or_clue("n", "<localleader>r", "+[R] console start/stop")
    key_or_clue("n", "<localleader>s", "+[s] to R")
    key_or_clue("n", "<localleader>b", "+[b]uild tools")
    key_or_clue("n", "<localleader>k", "+[k]nitting tools")

    -- start/stop R
    keymap_buffer(ev.buf, "n", "<localleader>rs", "<Plug>RStart<cr>", opts, "[s]tart R console")
    keymap_buffer(ev.buf, "n", "<localleader>rq", "<Plug>RClose<cr>", opts, "[q]uit R console (no save)")
    keymap_buffer(ev.buf, "n", "<localleader>rw", "<Plug>RSaveClose<cr>", opts, "quit and [w]rite R console")

    -- console
    keymap_buffer(ev.buf, "n", "<localleader>rl", "<Plug>RClearConsole<cr>", opts, "c[l]ear the R console")

    -- Send code
    keymap_buffer(ev.buf, "n", "<C-CR>", "<Plug>RDSendLine", opts, "send [l]ine and move down")
    keymap_buffer(ev.buf, "v", "<C-CR>", "<Plug>RDSendSelection", opts, "send [l]ine and move down")
    keymap_buffer(ev.buf, "n", "<C-S-CR>", "<Plug>RDSendParagraph", opts, "send [p]aragraph and move down")
    keymap_buffer(ev.buf, "n", "<localleader>sp", "<Plug>RDSendParagraph", opts, "send [p]aragraph and move down")
    keymap_buffer(ev.buf, "n", "<localleader>sl", "<Plug>RDSendLine", opts, "send [l]ine and move down")
    keymap_buffer(ev.buf, "n", "<localleader>sf", "<Plug>RSendFile", opts, "send [f]ile")

    if isModuleAvailable("quarto") then
      -- Quarto
      keymap_buffer(ev.buf, "n", "<localleader>qp", "<Plug>RQuartoPreview", opts, "[q]uarto [p]review")
      keymap_buffer(ev.buf, "n", "<localleader>qs", "<Plug>RQuartoStop", opts, "[q]uarto [s]top")
      keymap_buffer(ev.buf, "n", "<localleader>qr", "<Plug>RQuartoRender", opts, "[q]uarto [r]ender")
    end

    -- Help/print
    keymap_buffer(ev.buf, "n", "<localleader>h", "<Plug>RHelp", opts, "[h]elp for item under cursor")
    keymap_buffer(ev.buf, "n", "<localleader>p", "<Plug>RObjectPr", opts, "[p]rint object under cursor")
    keymap_buffer(ev.buf, "n", "<localleader>vd", "<Plug>RViewDFa", opts, "[v]iew [d]ata.frame head")

    -- Knit
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>kh",
      '<cmd>lua require("hades.misc.r_utils").spin_r("' .. vim.fn.expand("%:p") .. '", "html")<CR>',
      opts,
      "[h]tml [k]nit"
    )

    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>kp",
      '<cmd>lua require("hades.misc.r_utils").spin_r("' .. vim.fn.expand("%:p") .. '", "pdf")<CR>',
      opts,
      "[p]df [k]nit"
    )
    --
    keymap_buffer(ev.buf, "n", "<localleader>kP", "<Plug>RMakePDF", opts, "make PDF")
    -- Build

    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bl",
      "<cmd>lua require('r.send').cmd('devtools::load_all()')<CR>",
      opts,
      "[l]oad all files"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bb",
      "<cmd>lua require('r.send').cmd('devtools::build()')<CR>",
      opts,
      "[b]uild pkg"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bi",
      "<cmd>lua require('r.send').cmd('devtools::install(args = \"--preclean --with-keep.source --no-multiarch\")')<CR>",
      opts,
      "[i]nstall pkg"
    )

    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bd",
      '<cmd>lua require(\'r.send\').cmd(\'devtools::document(roclets = c("rd", "collate", "namespace", "vignette"))\')<CR>',
      opts,
      "[d]ocument pkg"
    )

    -- Objects
    keymap_buffer(ev.buf, "n", "<localleader>o", "<Plug>ROBToggle", opts, "[o]bject inspector toggle")
  end,
})
