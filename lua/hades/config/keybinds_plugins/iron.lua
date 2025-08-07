local M = {}

function M.load_keys(ev)
    local opts = require("hades.utils.keys").opts
    local keymap_buffer = require("hades.utils.keys").keymap_buffer
    local iron = require("iron.core")

    -- start/stop R
    keymap_buffer(ev.buf, "n", "<localleader>rs", "<cmd>IronRepl<cr>", opts, "[r]epl [s]tart (iron)")
    keymap_buffer(ev.buf, "n", "<localleader>rr", "<cmd>IronRepl<cr>", opts, "[r]epl [r]e-start (iron)")


    -- console
    keymap_buffer(ev.buf, "n", "<localleader>rl", function()
        require("iron.core").send(nil, { "\x0c" }) -- Ctrl + l
      end, opts, "c[l]ear the R console (iron)")
    --
    -- Send code
    keymap_buffer(ev.buf, "n", "<C-CR>", "<cmd>lua require('iron.core').send_paragraph()<cr>", opts, "send [p]paragraph (iron)")
    keymap_buffer(ev.buf, "v", "<C-CR>", "<cmd>lua require('iron.core').visual_send()<cr>", opts, "send [v]isual (iron)")

    keymap_buffer(ev.buf, "n", "<C-S-CR>", "<cmd>lua require('iron.core').send_line()<cr>", opts, "send [l]ine and move down (iron)")

    keymap_buffer(ev.buf, "n", "<localleader>sf", "<cmd>lua require('iron.core').send_file()", opts, "send [f]ile (iron)")
    keymap_buffer(ev.buf, "n", "<localleader>su", "<cmd>lua require('iron.core').send_until_cursor()", opts, "send [u]ntil cursor (iron)")

    keymap_buffer(ev.buf, "n", "<localleader>p", function()
      local word = vim.fn.expand("<cword>")
      local command = "print(" .. word .. ")"
      require("iron.core").send(nil, { command })
    end, opts, "[p]rint variable (iron)")


    --
    -- -- Quarto
    -- keymap_buffer(ev.buf, "n", "<localleader>qp", "<Plug>RQuartoPreview", opts, "[q]uarto [p]review")
    -- keymap_buffer(ev.buf, "n", "<localleader>qs", "<Plug>RQuartoStop", opts, "[q]uarto [s]top")
    -- keymap_buffer(ev.buf, "n", "<localleader>qr", "<Plug>RQuartoRender", opts, "[q]uarto [r]ender")
    --
    -- -- Help/print
    -- keymap_buffer(ev.buf, "n", "<localleader>h", "<Plug>RHelp", opts, "[h]elp for item under cursor")
    -- keymap_buffer(ev.buf, "n", "<localleader>p", "<Plug>RObjectPr", opts, "[p]rint object under cursor")
    -- keymap_buffer(ev.buf, "n", "<localleader>vd", "<Plug>RViewDFa", opts, "[v]iew [d]ata.frame head")
    --
    -- keymap_buffer(
    --   ev.buf,
    --   "n",
    --   "<localleader>kr",
    --   '<cmd>lua require("hades.utils.r_commands").rmarkdown_render("' .. vim.fn.expand("%:p") .. '")<CR>',
    --   opts,
    --   "[k]nit [r]evealjs"
    -- )
    --
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>kh",
      -- '<cmd>lua require("hades.utils.r_commands").spin_r("' .. vim.fn.expand("%:p") .. '", "html")<CR>',
      '<cmd>lua require("hades.utils.r_commands").rmarkdown_render("'
        .. vim.fn.expand("%:p")
        .. '")<CR>',
      opts,
      "[k]nit [h]tml"
    )
    --
    -- keymap_buffer(
    --   ev.buf,
    --   "n",
    --   "<localleader>kp",
    --   -- '<cmd>lua require("hades.utils.r_commands").spin_r("' .. vim.fn.expand("%:p") .. '", "pdf")<CR>',
    --   '<cmd>lua require("hades.utils.r_commands").rmarkdown_render("'
    --     .. vim.fn.expand("%:p")
    --     .. '")<CR>',
    --   opts,
    --   "[k]nit [p]df"
    -- )
    --
    -- -- keymap_buffer(ev.buf, "n", "<localleader>kP", "<Plug>RMakePDF", opts, "make PDF")
    -- -- Build
    --
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bl",
      function()
        require("iron.core").send(nil, { "devtools::load_all()" })
      end,
      opts,
      "[l]oad all files"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bi",
      function()
        require("iron.core").send(nil, { "devtools::install(args = \"--preclean --with-keep.source --no-multiarch\")" })
      end,
      opts,
      "[i]nstall pkg"
    )

    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bb",
      function()
        require("iron.core").send(nil, { "devtools::build()" })
      end,
      opts,
      "[b]uild pkg (iron)"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bT",
      function()
        require("iron.core").send(nil, { "devtools::test()" })
      end,
      opts,
      "[T]est pkg (iron)"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bt",
      function()
        require("iron.core").send(nil, { string.format("testthat::test_file(\"tests/testthat/test-%s\")", vim.fn.expand("%:t")) })
      end,
      opts,
      "[t]est file (iron)"
    )

    -- keymap_buffer(
    --   ev.buf,
    --   "n",
    --   "<localleader>bT",
    --   function()
    --     require("iron.core").send(nil, { string.format("usethis::use_test(\"%s\")", vim.fn.expand("%:t")) })
    --   end,
    --   opts,
    --   "create [T]est for file (iron)"
    -- )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>bd",
      function()
        require("iron.core").send(nil, { "devtools::document(roclets = c(\"rd\", \"collate\", \"namespace\", \"vignette\"))" })
      end,
      opts,
      "[d]ocument pkg (iron)"
    )
    --
    -- -- Objects
    -- keymap_buffer(ev.buf, "n", "<localleader>o", "<Plug>ROBToggle", opts, "[o]bject inspector toggle")
end
return M
