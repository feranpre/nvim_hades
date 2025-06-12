--
-- This keybinds are only loaded when a markdown file is entered
--
-- configuration_file: ~/.config/nvim/ftplugin/markdown.lua
--

--
-- QUARTO
--

-- local keymap = require("hades.utils.keys").keymap
if IsModuleAvailable("quarto") then
  if DEBUG then
    print("Quarto - keys loaded")
  end

  local M = {}

  function M.load_keys(ev)
    local key_or_clue = require("hades.utils.keys").key_or_clue
    local keymap_buffer = require("hades.utils.keys").keymap_buffer
    local opts = require("hades.utils.keys").opts

    local isModuleAvailable = require("hades.utils.keys").isModuleAvailable
    local fer_quarto = require("hades.utils.fer_quarto")

    --- Insert code chunk of given language
    --- Splits current chunk if already within a chunk
    --- @param lang string
    local insert_code_chunk = function(lang)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
      local keys
      if fer_quarto.is_code_chunk() then
        keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
      else
        keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
      end
      keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end

    local insert_r_chunk = function()
      insert_code_chunk("r")
    end

    local insert_py_chunk = function()
      insert_code_chunk("python")
    end

    local insert_lua_chunk = function()
      insert_code_chunk("lua")
    end

    local insert_julia_chunk = function()
      insert_code_chunk("julia")
    end

    local insert_bash_chunk = function()
      insert_code_chunk("bash")
    end

    local insert_ojs_chunk = function()
      insert_code_chunk("ojs")
    end

    keymap_buffer(ev.buf, "n", "<C-S-CR>", fer_quarto.send_paragraph_by_lang, opts, "send paragraph by language")
    keymap_buffer(ev.buf, "v", "<C-CR>", fer_quarto.send_paragraph_by_lang, opts, "send visual selection by language")
    keymap_buffer(ev.buf, "n", "<C-CR>", fer_quarto.send_line_by_lang, opts, "send line by language")

    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>sc",
      '<cmd>lua require("quarto.runner").run_cell()<CR>',
      opts,
      "[s]end [c]ell"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>sa",
      '<cmd>lua require("quarto.runner").run_above()<CR>',
      opts,
      "[s]end [a]bove"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>sA",
      '<cmd>lua require("quarto.runner").run_all()<CR>',
      opts,
      "[s]end [A]ll"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>sb",
      '<cmd>lua require("quarto.runner").run_below()<CR>',
      opts,
      "[s]end [b]elow"
    )

    keymap_buffer(ev.buf, "n", "<localleader>p", function()
      local word = vim.fn.expand("<cword>")
      local command = "print(" .. word .. ")"
      require("iron.core").send(nil, { command })
    end, opts, "[p]rint variable (iron)")

    -- local fer_quarto = require("hades.misc.slime_utils")
    -- keymap_buffer(0, "n", "<C-CR>", fer_quarto.send_cell(), opts, "[q]uarto send files")
    -- keymap_buffer(0, "n", "<C-CR>", send_cell, opts, "[q]uarto send cell")
    -- keymap_buffer(ev.buf, "n", "<localleader>sc", send_cell, opts, "[q]uarto send cell")
    -- keymap_buffer(ev.buf, "n", "<localleader>sc", send_cell, opts, "[q]uarto send cell")
    -- keymap_buffer(ev.buf, "n", "<C-CR>", send_cell, opts, "[q]uarto send files")
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>qp",
      "<cmd>lua require('quarto').quartoPreview()<CR>",
      opts,
      "[q]uarto [p]review"
    )
    keymap_buffer(
      ev.buf,
      "n",
      "<localleader>qc",
      "<cmd>lua require('quarto').quartoClosePreview()<CR>",
      opts,
      "[q]uarto [c]lose preview"
    )

    keymap_buffer(ev.buf, "n", "<localleader>qI", insert_r_chunk, opts, "[I]nsert R chunk")
    keymap_buffer(ev.buf, "n", "<localleader>qi", insert_py_chunk, opts, "[i]nsert PYTHON chunk")

    -- CHUNKS
    keymap_buffer(ev.buf, "n", "<C-i>", insert_r_chunk, opts, "[i]nsert R chunk")
    keymap_buffer(ev.buf, "n", "<C-I>", insert_py_chunk, opts, "[I]nsert PYTHON chunk")
    keymap_buffer(ev.buf, "i", "<C-i>", insert_r_chunk, opts, "[i]nsert R chunk")
    keymap_buffer(ev.buf, "i", "<C-I>", insert_py_chunk, opts, "[I]nsert PYTHON chunk")

    -- TERMINALS
    -- keymap_buffer(ev.buf, "n", "<localleader>rs", new_terminal_r, opts, "[R] [s]tart terminal")
    -- key_or_clue("n", "<localleader>qt", "+[t]erminals ([q]arto)")

    -- keymap_buffer(ev.buf, "n", "<localleader>qtp", new_terminal_python, opts, "new [p]ython terminal")
    -- keymap_buffer(ev.buf, "n", "<localleader>qti", new_terminal_ipython, opts, "new [i]python terminal")

    -- ------------------------
    -- ------------------------ OTTER
    -- ------------------------

    if isModuleAvailable("otter") then
      keymap_buffer(ev.buf, "n", "<localleader>qe", require("otter").export, opts, "[e]xport (otter)")
      keymap_buffer(ev.buf, "n", "<localleader>oa", require("otter").activate, opts, "[o]tter [a]ctivate (toggle)")
    end

    -- robar todo de [aqui](https://github.com/jmbuhr/quarto-nvim-kickstarter/blob/main/lua/config/keymap.lua)
    --
    -- ------------------------
    -- ------------------------ NABLA
    -- ------------------------
    if isModuleAvailable("nabla") then
      keymap_buffer(ev.buf, "n", "<localleader>qm", require("nabla").toggle_virt, opts, "toggle [m]ath equations")
    end

    -- ------------------------
    -- ------------------------ IMAGE.VIM
    -- ------------------------
    keymap_buffer(ev.buf, "n", "<localleader>ii", "<cmd>PasteImage<cr>", opts, "insert [i]mage from clipboard")
  end
  return M
else
  if DEBUG then
    print("Quarto - keys NOT loaded")
  end
end
