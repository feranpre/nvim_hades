local opts = { noremap = true, silent = true, desc = nil }

local keymap = require("hades.misc.utils").keymap
local keymap_buffer = require("hades.misc.utils").keymap_buffer
local isModuleAvailable = require("hades.misc.utils").isModuleAvailable
local generate_html_from_rscript = require("hades.misc.utils").generate_html_from_rscript

local wk = nil
if isModuleAvailable("which-key") then
  wk = require("which-key")
  wk.add({
    { "<leader>l", group = "+[L]azy" },
    { "g", group = "+[g]o" },
  })
  keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts, "open [L]azy window")
  keymap("n", "<F2>", "<cmd>WhichKey<cr>", opts, "[k]eybinds - help")
  keymap("n", "<leader>k", "<cmd>WhichKey<cr>", opts, "[k]eybinds - help")
  keymap("n", "<leader>?", function()
    wk.show({ global = false })
  end, opts, "[?] buffer keybinds")
end

-- Press jk fast to enter
keymap("i", "kj", "<ESC>", opts, "exit insert mode")

keymap("n", "<ESC>", "<cmd>nohl<cr>", opts, "remove hilights")

-- Navigate buffers
keymap("n", "<S-l>", "<cmd>bnext<CR>", opts, "next buffer")
keymap("n", "<S-h>", "<cmd>bprevious<CR>", opts, "previous buffer")
keymap("n", "<C-q>", "<cmd>q<CR>", opts, "[q]uit buffer")

-- save file
keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", opts, "[s]ave file")
keymap("n", "<leader>qq", "<cmd>qa<cr>", opts, "[q]uit all")

-- Uber yank --
keymap({ "n", "v" }, "<leader>y", '"+y', opts, "[y]ank out of nvim")

-- windows
if wk ~= nil then
  wk.add({
    "<leader>w",
    group = "+[w]indows",
  })
end

-- window creation
keymap("n", "<leader>ww", "<C-w>p", opts, "activate other [w]indow")
keymap("n", "<leader>wd", "<C-w>c", opts, "[d]elete window")
keymap("n", "<leader>w-", "<C-w>s", opts, "[s]plit window below")
keymap("n", "<leader>w|", "<C-w>v", opts, "split window [v]ertical (right)")

-- window resize
keymap("n", "<S-Up>", "<cmd>resize +2<CR>", opts, "resize window [u]p")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>", opts, "resize window [d]own")
keymap("n", "<S-Left>", "<cmd>vertical resize +2<CR>", opts, "resize window [l]eft")
keymap("n", "<S-Right>", "<cmd>vertical resize -2<CR>", opts, "resize window [r]ight")

keymap("n", "<C-S-k>", "<cmd>resize +2<CR>", opts, "resize window [u]p")
keymap("n", "<C-S-j>", "<cmd>resize -2<CR>", opts, "resize window [d]own")
keymap("n", "<C-S-h>", "<cmd>vertical resize +2<CR>", opts, "resize window [l]eft")
keymap("n", "<C-S-l>", "<cmd>vertical resize -2<CR>", opts, "resize window [r]ight")

keymap("n", "<leader>wk", "<cmd>resize +2<CR>", opts, "resize window [u]p <C-S-k>")
keymap("n", "<leader>wj", "<cmd>resize -2<CR>", opts, "resize window [d]own <C-S-j>")
keymap("n", "<leader>wh", "<cmd>vertical resize +2<CR>", opts, "resize window [l]eft <C-S-l>")
keymap("n", "<leader>wl", "<cmd>vertical resize -2<CR>", opts, "resize window [r]ight <C-S-h>")

-- window rotation

keymap("n", "<leader>wK", "<C-w>K", opts, "move window to the top [<C-w>K]")
keymap("n", "<leader>wJ", "<C-w>J", opts, "move window to the bottom [<C-w>J]")
keymap("n", "<leader>wL", "<C-w>L", opts, "move window to the left [<C-w>L]")
keymap("n", "<leader>wH", "<C-w>H", opts, "move window to the right [<C-w>H]")

-- buffer
if wk ~= nil then
  wk.add({
    "<leader>b",
    group = "+[b]uffers",
  })
end
keymap("n", "<leader>bl", "<cmd>Telescope buffers<cr>", opts, "Telescope [b]uffer list")
keymap("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", opts, "[b]uffer [d]elete")
keymap("n", "<leader>bD", "<cmd>%bd|e#<CR>", opts, "[b]uffer [D]elete all but current")

-- indenting
keymap("v", "<", "<gv", opts, "un-Indent selected text")
keymap("v", ">", ">gv", opts, "indent selected text")

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Spelling --
keymap("n", "]s", "]s", opts, "next misspelled word")
keymap("n", "[s", "[s", opts, "prev misspelled word")
keymap("n", "zg", "zg", opts, "[g]ood word to add to dictionary (spelling)")
keymap("n", "zG", "zG", opts, "[G]ood word to add to internal dictionary (spelling)")
keymap("n", "zug", "zug", opts, "[u]ndo add [g]ood word to dictionary (spelling)")
keymap("n", "zuG", "zuG", opts, "[u]ndo add [G]ood word to internal dictionary (spelling)")
keymap("n", "zw", "zw", opts, "[w]rong word to add to dictionary (spelling)")
keymap("n", "zW", "zW", opts, "[W]rong word to add to internal dictionary (spelling)")
keymap("n", "z=", "z=", opts, "check possible replacements for word (spelling)")

-- -------------------------------------
-- ------------------------------------- R.nvim
-- -------------------------------------
-- vim.g.maplocalleader = ","
-- vim.api.nvim_buf_set_keymap(0, "n", "<localleader>t", ":echo 'Test mapping'<CR>", { noremap = true, silent = true })
if isModuleAvailable("r") then
  vim.api.nvim_create_autocmd({ "FileType", "VimEnter", "BufEnter" }, {
    pattern = "r",
    callback = function(ev)
      print("-- Loading R keys --", ev.buf)
      -- local send = require('r.send').cmd
      -- keymap_buffer(0, "n", "<localleader>ll", send("devtools::load_all()"), opts, "asersd")

      if wk ~= nil then
        local b_opts = { buffer = ev.buf }
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

-- -------------------------------------
-- ------------------------------------- SPECTRE
-- -------------------------------------
if isModuleAvailable("spectre") then
  keymap("n", "<leader>S", "<cmd>lua require('spectre').toggle()<CR>", opts, "Toggle Spectre")
  keymap(
    "n",
    "<leader>Sw",
    "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
    opts,
    "Search current word"
  )
  keymap("v", "<leader>Sw", "<esc><cmd>lua require('spectre').open_visual()<CR>", opts, "Search current word")
  keymap(
    "n",
    "<leader>Sp",
    "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>",
    opts,
    "Search on current file"
  )
end

-- -------------------------------------
-- ------------------------------------- SLIME
-- -------------------------------------
if vim.g.slime_target ~= nil then
  -- local slime_run = require('hades.misc.slime_utils')
  wk.add({ "<LocalLeader>s", group = "+[S]end (REPL)" })
  keymap("n", "<C-CR>", "<Plug>SlimeParagraphSend", opts, "other window")
  keymap("n", "<LocalLeader>sp", "<Plug>SlimeParagraphSend", opts, "other window")

  keymap(
    "n",
    "<LocalLeader>sl",
    "<cmd>SlimeSend1 devtools::load_all('.')<CR>",
    opts,
    "R - load all files (for a package)"
  )
  -- keymap("n", "<localleader>rs", slime_run.send_cell, opts, "other window")
  -- keymap("n", "<leader>rr", slime_run.send_cell, opts, "other window")
end
--
-- -------------------------------------
-- ------------------------------------- FILE TREE
-- -------------------------------------
-- if isModuleAvailable("nvim-tree") then
--   keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts, "open [e]xplorer") -- abre el navegador
if isModuleAvailable("neo-tree") then
  keymap("n", "<leader>e", ":Neotree toggle<CR>", opts, "open explorer") -- abre el navegador
else
  keymap("n", "<leader>e", ":Lex 30<CR>", opts, "open [e]xplorer") -- abre el navegador
end

-- -------------------------------------
-- ------------------------------------- UNDO TREE
-- -------------------------------------
if vim.g.loaded_undotree ~= nil then
  keymap("n", "<leader><F5>", "<cmd>UndotreeToggle<CR>", opts, "undotree")
  keymap("n", "<C-u>", "<cmd>UndotreeToggle<CR>", opts, "undotree")
end

-- -------------------------------------
-- ------------------------------------- TMUX NAV
-- -------------------------------------
if isModuleAvailable("tmux-navigator") then
  keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts, "navigate to the left window")
  keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts, "navigate to the lower window")
  keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts, "navigate to the upper window")
  keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts, "navigate to the right window")
  -- keymap("n", "<cmd>TmuxNavigatePrevious<cr>", opts, "navigate to the   window")
end

-- -------------------------------------
-- ------------------------------------- TELESCOPE
-- -------------------------------------
if isModuleAvailable("telescope.builtin") then
  if wk ~= nil then
    wk.add({
      "<leader>f",
      group = "+[f]ind (telescope)",
    })
  end
  -- Telescope --
  -- Find files in project
  keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts, "[f]ind [f]ile")
  keymap("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", opts, "find [k]eymaps")
  keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", opts, "find [r]ecent file")
  keymap("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", opts, "find string in this [d]ir")
  keymap("n", "<leader>fg", "<cmd>Telescope grep_string<CR>", opts, "find string under cursor in dir")
  keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts, "find [b]uffer")
  keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts, "find in [h]elp")

  -- local actions = require('telescope.actions')
  -- keymap("n", "<Down>", function()
  --   actions.move_selection_next()
  -- end, opts, "Telescope -> next item in list")
  -- keymap("n", "<Up>", function()
  --   actions.move_selection_previous()
  -- end, opts, "Telescope -> previous item in list")
  --
  -- keymap("i", "<C-q>", function()
  --   actions.send_selected_to_qflist()
  --   actions.open_qflist()
  -- end, opts, "move to prev result")
end

-- ------ LSP CONFIG
if isModuleAvailable("lspconfig") then
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      -- local opts = { buffer = ev.buf }
      keymap_buffer(0, "n", "gR", "<cmd>Telescope lsp_references<CR>", opts, "LSP -> show definition references")
      keymap_buffer(0, "n", "gD", "<cmd>lua vim.lsp.buf.declaration() <CR>", opts, "LSP -> go to definition")
      keymap_buffer(0, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts, "LSP -> show lsp definitions")
      keymap_buffer(0, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts, "LSP -> show implementations") -- show lsp implementations
      keymap_buffer(0, "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts, "LSP -> show type definitions") -- show lsp implementations

      keymap_buffer(
        0,
        "n",
        "<leader>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        opts,
        "LSP -> see available code actions"
      ) -- show lsp implementations
      keymap_buffer(
        0,
        "v",
        "<leader>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        opts,
        "LSP -> see available code actions"
      ) -- show lsp implementations

      keymap_buffer(0, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename() <CR>", opts, "LSP -> smart rename") -- smart rename
      keymap_buffer(
        0,
        "n",
        "<leader>d",
        "<cmd>lua vim.diagnostic.open_float() <CR>",
        opts,
        "LSP -> show line diagnostics"
      ) -- smart rename
      keymap_buffer(
        0,
        "n",
        "<leader>D",
        "<cmd>Telescope diagnostics bufnr=0<CR>",
        opts,
        "LSP -> show buffer diagnostics"
      ) -- show lsp implementations
      keymap_buffer(
        0,
        "n",
        "<leader>[d",
        "<cmd>lua vim.diagnostic.goto_prev()<CR>",
        opts,
        "LSP -> go to prev diagnostic"
      )
      keymap_buffer(
        0,
        "n",
        "<leader>]d",
        "<cmd>lua vim.diagnostic.goto_next()<CR>",
        opts,
        "LSP -> go to next diagnostic"
      )

      keymap_buffer(
        0,
        "n",
        "K",
        "<cmd>lua vim.lsp.buf.hover()<CR>",
        opts,
        "LSP -> Show documentation for whatever is under cursor"
      )
      keymap_buffer(0, "n", "<leader>rs", "<cmd>LspRestart<CR>", opts, "LSP -> restart LSP")
    end,
  })
end

-- ------ CMP
if isModuleAvailable("cmp") then
  local cmp = require("cmp")
  local cmp_select = { behavior = cmp.SelectBehavior.Select }
  keymap("i", "<C-p>", cmp.mapping.select_prev_item(cmp_select), opts, "[p]rev autocomplete item")
  keymap("i", "<C-n>", cmp.mapping.select_next_item(cmp_select), opts, "[n]ext autocomplete item")
  -- keymap("i", "<C-k>", cmp.mapping.select_prev_item(cmp_select), opts, "prev autocomplete item")
  -- keymap("i", "<C-j>", cmp.mapping.select_next_item(cmp_select), opts, "next autocomplete item")
  keymap("i", "<C-Space>", cmp.mapping.complete(), opts, "show autocomplete")
  keymap("i", "<C-e>", cmp.mapping.abort(), opts, "[e]xit autocomplete")
  keymap("i", "<C-y>", cmp.mapping.confirm({ select = true }), opts, "accept autocomplete item")
end

-- ------ LuaSnips
if isModuleAvailable("luasnip") then
  local ls = require("luasnip")
  keymap("i", "<C-l>", function()
    ls.jump(1)
  end, opts, "jump to next snippet item")
  keymap("i", "<C-h>", function()
    ls.jump(-1)
  end, opts, "jump to prev snippet item")
end

-- -------- QUARTO
--
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

if isModuleAvailable("quarto") then
  -- local fer_quarto = require("hades.misc.slime_utils")
  -- keymap("n", "<C-CR>", fer_quarto.send_cell(), opts, "[q]uarto send files")
  keymap("n", "<C-CR>", send_cell, opts, "[q]uarto send files")
  keymap("n", "<m-i>", insert_r_chunk, opts, "insert R code chunk [q]uarto send files")
  keymap("n", "<leader>qp", "<cmd>lua require('quarto').quartoPreview()<CR>", opts, "quarto [p]review")
  -- robar todo de [aqui](https://github.com/jmbuhr/quarto-nvim-kickstarter/blob/main/lua/config/keymap.lua)
end
--
-- -------- TERMINAL
if isModuleAvailable("toggleterm") then
  local term = require("toggleterm")
  if wk ~= nil then
    wk.add({
      "<leader>t",
      group = "[t]erminal",
    })
  end
  keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", opts, "[t]oggle [t]erm")
  keymap("n", "<leader>tr", "<cmd>vsplit term://R<cr>", opts, "new [r] terminal")
end

-- -------- HARPOON

if isModuleAvailable("harpoon") then
  local harpoon = require("harpoon")
  keymap("n", "<leader>a", function()
    harpoon:list():add()
  end, opts, "[a]dd file to harpoon list")
  keymap("n", "<C-q>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, opts, "[q]uick harpoon list")

  keymap("n", "<C-1>", function()
    harpoon:list():select(1)
  end, opts, "harpoon list - 1")
  keymap("n", "<C-2>", function()
    harpoon:list():select(2)
  end, opts, "harpoon list - 2")
  keymap("n", "<C-3>", function()
    harpoon:list():select(3)
  end, opts, "harpoon list - 3")
  keymap("n", "<C-4>", function()
    harpoon:list():select(4)
  end, opts, "harpoon list - 4")
  keymap("n", "<C-5>", function()
    harpoon:list():select(5)
  end, opts, "harpoon list - 5")
  keymap("n", "<C-6>", function()
    harpoon:list():select(6)
  end, opts, "harpoon list - 6")
  keymap("n", "<C-7>", function()
    harpoon:list():select(7)
  end, opts, "harpoon list - 7")
  keymap("n", "<C-8>", function()
    harpoon:list():select(8)
  end, opts, "harpoon list - 8")
  keymap("n", "<C-9>", function()
    harpoon:list():select(9)
  end, opts, "harpoon list - 9")

  -- Toggle previous & next buffers stored within Harpoon list
  keymap("n", "<C-S-P>", function()
    harpoon:list():prev()
  end, opts, "[p]revious harpool file")
  keymap("n", "<C-S-N>", function()
    harpoon:list():next()
  end, opts, "[n]ext harpoon file")
end

keymap("n", "<leader>vs", "<cmd>VenvSelect<cr>", opts, "[v]env [s]election")
