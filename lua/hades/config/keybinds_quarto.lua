local opts = { noremap = true, silent = true, desc = nil }

local keymap = require("hades.misc.utils").keymap
local keymap_buffer = require("hades.misc.utils").keymap_buffer
local isModuleAvailable = require("hades.misc.utils").isModuleAvailable

if isModuleAvailable("quarto") then
  local function send_cell()
    if vim.b["quarto_is_r_mode"] == nil then
      vim.fn["slime#send_cell"]()
      return
    end
    if vim.b["quarto_is_r_mode"] == true then
      vim.g.slime_python_ipython = 0
      local is_python = require("otter.tools.functions").is_otter_language_context("python")
      if is_python and not vim.b["reticulate_running"] then
        vim.fn["slime#send"]("reticulate::repl_python()" .. "\r")
        vim.b["reticulate_running"] = true
      end
      if not is_python and vim.b["reticulate_running"] then
        vim.fn["slime#send"]("exit" .. "\r")
        vim.b["reticulate_running"] = false
      end
      vim.fn["slime#send_cell"]()
    end
  end

  --- Send code to terminal with vim-slime
  --- If an R terminal has been opend, this is in r_mode
  --- and will handle python code via reticulate when sent
  --- from a python chunk.
  local slime_send_region_cmd = ":<C-u>call slime#send_op(visualmode(), 1)<CR>"
  slime_send_region_cmd = vim.api.nvim_replace_termcodes(slime_send_region_cmd, true, false, true)

  local function send_region()
    -- if filetyps is not quarto, just send_region
    if vim.bo.filetype ~= "quarto" or vim.b["quarto_is_r_mode"] == nil then
      vim.cmd("normal" .. slime_send_region_cmd)
      return
    end
    if vim.b["quarto_is_r_mode"] == true then
      vim.g.slime_python_ipython = 0
      local is_python = require("otter.tools.functions").is_otter_language_context("python")
      if is_python and not vim.b["reticulate_running"] then
        vim.fn["slime#send"]("reticulate::repl_python()" .. "\r")
        vim.b["reticulate_running"] = true
      end
      if not is_python and vim.b["reticulate_running"] then
        vim.fn["slime#send"]("exit" .. "\r")
        vim.b["reticulate_running"] = false
      end
      vim.cmd("normal" .. slime_send_region_cmd)
    end
  end

  local is_code_chunk = function()
    local current, _ = require("otter.keeper").get_current_language_context()
    if current then
      return true
    else
      return false
    end
  end

  --- Insert code chunk of given language
  --- Splits current chunk if already within a chunk
  --- @param lang string
  local insert_code_chunk = function(lang)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
    local keys
    if is_code_chunk() then
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
  local function new_terminal(lang)
    vim.cmd("vsplit term://" .. lang)
  end

  local function new_terminal_python()
    new_terminal("python")
  end

  local function new_terminal_r()
    new_terminal("R --no-save")
  end

  local function new_terminal_ipython()
    new_terminal("ipython --no-confirm-exit")
  end

  local function new_terminal_julia()
    new_terminal("julia")
  end

  local function new_terminal_shell()
    new_terminal("$SHELL")
  end

  -- local fer_quarto = require("hades.misc.slime_utils")
  -- keymap("n", "<C-CR>", fer_quarto.send_cell(), opts, "[q]uarto send files")
  keymap("n", "<C-CR>", send_cell, opts, "[q]uarto send files")
  keymap("n", "<C-CR>", send_cell, opts, "[q]uarto send files")
  keymap("n", "<leader>qp", "<cmd>lua require('quarto').quartoPreview()<CR>", opts, "quarto [p]review")

  -- CHUNKS
  keymap("n", "<m-i>", insert_r_chunk, opts, "[i]nsert R chunk")
  keymap("n", "<m-I>", insert_py_chunk, opts, "[I]nsert PYTHON chunk")

  -- TERMINALS
  keymap("n", "<leader>cr", function()
    vim.b["quarto_is_r_mode"] = true
    new_terminal_r()
  end, opts, "new [R] terminal")

  keymap("n", "<leader>cp", new_terminal_python, opts, "new [p]ython terminal")
  keymap("n", "<leader>ci", new_terminal_ipython, opts, "new [i]python terminal")

  keymap("n", "<leader>qe", require("otter").export, opts, "[e]xport (otter)")

  -- robar todo de [aqui](https://github.com/jmbuhr/quarto-nvim-kickstarter/blob/main/lua/config/keymap.lua)
  --
  -- ------------------------
  -- ------------------------ NABLA
  -- ------------------------
  keymap("n", "<leader>qm", require("nabla").toggle_virt, opts, "toggle [m]ath equations")

  -- ------------------------
  -- ------------------------ IMAGE.VIM
  -- ------------------------
  keymap("n", "<leader>ii", "<cmd>PasteImage<cr>", opts, "insert [i]mage from clipboard")

  -- ------------------------
  -- ------------------------ SLIME
  -- ------------------------
  local function mark_terminal()
    local job_id = vim.b.terminal_job_id
    vim.print("job_id: " .. job_id)
  end

  local function set_terminal()
    vim.fn.call("slime#config", {})
  end
  keymap("n", "<leader>cm", mark_terminal, opts, "[m]ark terminal")
  keymap("n", "<leader>cs", set_terminal, opts, "[s]et terminal")
  keymap("n", "<C-CR>", "<Plug>SlimeLineSend", opts, "other window")
  keymap("v", "<C-CR>", "<Plug>SlimeRegionSend", opts, "other window")
  keymap("n", "<C-S-CR>", "<Plug>SlimeParagraphSend", opts, "other window")
end
