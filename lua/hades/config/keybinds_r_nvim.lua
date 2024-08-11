local isModuleAvailable = require("hades.misc.utils").isModuleAvailable
if isModuleAvailable("r") then
  vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
    desc = "r file binds",
    pattern = { "r", "quarto" },
    callback = function(ev)
      local opts = { noremap = true, silent = true, desc = nil }
      -- local keymap = require("hades.misc.utils").keymap
      local keymap_buffer = require("hades.misc.utils").keymap_buffer

      local wk = require("which-key")
      print("-- Loading R keys --", ev.buf)
      -- local send = require('r.send').cmd
      -- keymap_buffer(0, "n", "<localleader>ll", send("devtools::load_all()"), opts, "asersd")

      if wk ~= nil then
        local b_opts = { buffer = ev.buf }
        vim.keymap.set("n", "<localleader>", function()
          require("which-key").show(",")
        end, { buffer = true })
        -- wk.register({ ["<localleader>"] = { name = "[R] commands" } }, b_opts)
        wk.add({ "<localleader>r", group = "[R] start/stop" }, b_opts)
        wk.add({ "<localleader>s", group = "[s]end to R" }, b_opts)
        wk.add({ "<localleader>b", group = "[b]uild tools" }, b_opts)
        wk.add({ "<localleader>k", group = "[k]nitting tools" }, b_opts)
      end

      -- start/stop R
      keymap_buffer(ev.buf, "n", "<localleader>rs", "<Plug>RStart<cr>", opts, "[s]tart R console")
      keymap_buffer(ev.buf, "n", "<localleader>rq", "<Plug>RClose<cr>", opts, "[q]uit R console (no save)")
      keymap_buffer(ev.buf, "n", "<localleader>rw", "<Plug>RSaveClose<cr>", opts, "quit and [w]rite R console")

      -- console
      keymap_buffer(ev.buf, "n", "<localleader>rl", "<Plug>RClearConsole<cr>", opts, "c[l]ear the R console")

      -- Send code
      keymap_buffer(ev.buf, "n", "<C-CR>", "<Plug>RDSendLine", opts, "send [l]ine and move down")
      keymap_buffer(ev.buf, "v", "<C-CR>", "<Plug>RDSendSelection", opts, "send [l]ine and move down")
      keymap_buffer(ev.buf, "n", "<localleader>sl", "<Plug>RDSendLine", opts, "send [l]ine and move down")
      keymap_buffer(ev.buf, "n", "<C-S-CR>", "<Plug>RDSendParagraph", opts, "send [p]aragraph and move down")
      keymap_buffer(ev.buf, "n", "<localleader>sp", "<Plug>RDSendParagraph", opts, "send [p]aragraph and move down")

      keymap_buffer(ev.buf, "n", "<localleader>sf", "<Plug>RSendFile", opts, "send [f]ile")

      -- Quarto
      keymap_buffer(ev.buf, "n", "<localleader>qp", "<Plug>RQuartoPreview", opts, "[q]uarto [p]review")
      keymap_buffer(ev.buf, "n", "<localleader>qr", "<Plug>RQuartoRender", opts, "[q]uarto [r]ender")

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
end
