vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  desc = "REPL for multiple languages",
  pattern = { "python" },
  callback = function(ev)
    print(" -- Loading Slime Keys --")
    local opts = { noremap = true, silent = true, desc = nil }
    local keymap = require("hades.misc.utils").keymap
    local keymap_buffer = require("hades.misc.utils").keymap_buffer
    local key_or_clue = require("hades.misc.utils").key_or_clue

    -- key_or_clue("n", "<localleader>b", "+[b]uild tools")
    -- key_or_clue("n", "<localleader>k", "+[k]nitting tools")

    -- wk.register({ ["<localleader>"] = { name = "[R] commands" } }, b_opts)
    -- wk.add({ "<localleader>r", group = "[R] start/stop" }, b_opts)
    -- wk.add({ "<localleader>s", group = "[s]end to R" }, b_opts)
    -- wk.add({ "<localleader>b", group = "[b]uild tools" }, b_opts)
    -- wk.add({ "<localleader>k", group = "[k]nitting tools" }, b_opts)
    -- end

    -- TERMINAL
    -- key_or_clue("n", "<localleader>t", "+[t]erminal (Slime)")
    keymap_buffer(ev.buf, "n", "<localleader>tn", "<Plug>SlimeConfig", opts, "(Slime)[t]erminal [n]ew conf")

    -- SEND
    -- key_or_clue("n", "<localleader>s", "+[s] to terminal (Slime)")
    keymap("n", "<CR>", "<Plug>SlimeLineSend<CR>", opts, "(Slime)[s]end [l]ine")
    -- keymap_buffer(ev.buf, "n", "<C-CR>", "<Plug>SlimeLineSend<CR>", opts, "(Slime)[s]end [l]ine")
    keymap_buffer(ev.buf, "n", "<localleader>sl", "<Plug>SlimeLineSend<CR>", opts, "(Slime) [s]end [l]ine")

    -- keymap_buffer(ev.buf, "v", "<C-CR>", "<Plug>SlimeRegionSend<CR>", opts, "(Slime)[s]end region")
    keymap_buffer(ev.buf, "n", "<localleader>sr", "<Plug>SlimeRegionSend<CR>", opts, "(Slime)[s]end [r]egion")
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>sc",
      "<Plug>SlimeSendCell<BAR>/^" .. vim.g.slime_cell_delimiter .. "<CR>",
      opts,
      "(Slime)[s]end [c]ell"
    )
  end,
})
