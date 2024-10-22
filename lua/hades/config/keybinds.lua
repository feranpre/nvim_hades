local opts = { noremap = true, silent = true, desc = nil }

local keymap = require("hades.misc.utils").keymap
local keymap_buffer = require("hades.misc.utils").keymap_buffer
local isModuleAvailable = require("hades.misc.utils").isModuleAvailable
-- local isAvailable = require("hades.misc.utils").isAvailable

local wk = nil
if isModuleAvailable("which-key.nvim") then
  print("which-key - keys loaded")
  wk = require("which-key")
  wk.add({
    { "<leader>l", group = "+[L]azy" },
    { "g", group = "+[g]o" },
  })
  vim.keymap.set("n", "<localleader>", function()
    wk.show(",")
  end, { buffer = true })

  keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts, "open [L]azy window")
  keymap("n", "<F2>", "<cmd>WhichKey<cr>", opts, "[k]eybinds - help")
  keymap("n", "<leader>k", "<cmd>WhichKey<cr>", opts, "[k]eybinds - help")
  keymap("n", "<leader>?", function()
    wk.show({ global = false })
  end, opts, "[?] buffer keybinds")
end

-- keymap("n", "<localleader>ip", function()
--   local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
--   if venv ~= nil then
--     -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
--     venv = string.match(venv, "/.+/(.+)")
--     vim.cmd(("MoltenInit %s"):format(venv))
--   else
--     vim.cmd("MoltenInit python3")
--   end
-- end, opts, "Initialize Molten for python3")
-- -------------------------------------
-- ------------------------------------- R.nvim
-- -------------------------------------
if isModuleAvailable("R.nvim") then
  print("R.nvim - keys loaded")
  require("hades.config.keybinds_r_nvim")
end

if isModuleAvailable("vim-slime") then
  print("vim-slime - keys loaded")
  require("hades.config.keybinds_slime_nvim")
end

-- local generate_html_from_rscript = require("hades.misc.utils").generate_html_from_rscript
-- Define the function to call the pandoc2pdf.py script
function PandocToPDF()
  -- Get the filename of the current buffer
  local filename = vim.api.nvim_buf_get_name(0)

  -- Call the shell command
  vim.fn.system("pandoc2pdf.py " .. vim.fn.shellescape(filename))

  -- Optionally print a message
  print("Converted " .. filename .. " to PDF")
end
keymap("n", "<leader>p", "<cmd>lua PandocToPDF()<CR>", opts, "pdf")

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
-- ------------------------------------- QUARTO
-- -------------------------------------
-- require("hades.config.keybinds_quarto")
keymap("n", "<leader>qp", "<cmd>lua require('quarto').quartoPreview()<CR>", opts, "[q]uarto [p]review")
keymap("n", "<leader>qc", "<cmd>lua require('quarto').quartoClosePreview()<CR>", opts, "[q]uarto [c]lose preview")

-- -------------------------------------
-- ------------------------------------- SPECTRE
-- -------------------------------------
if isModuleAvailable("nvim-spectre") then
  print("nvim-spectre - keys loaded")
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
-- if vim.g.slime_target ~= nil then
-- local slime_run = require("hades.misc.slime_utils")
-- print("SILIME???")
-- print(isModuleAvailable("vim-slime"))
-- if isModuleAvailable("vim-slime") then
--   print("vim-slime - keys loaded")
--   if wk ~= nil then
--     wk.add({ "<LocalLeader>sl", group = "+[S]end (REPL)" })
--   end
--   keymap("n", "<C-CR>", "<Plug>SlimeParagraphSend", opts, "other window")
--   keymap("n", "<localleader>sp", "<Plug>SlimeParagraphSend", opts, "[s]end [p]aragraph")
--
--   keymap("n", "<LocalLeader>bl", "<cmd>SlimeSend1 devtools::load_all('.')<CR>", opts, "[b]uild [l]oad all")
--   keymap("n", "<LocalLeader>tc", "<cmd>SlimeConfig<CR>", opts, "[t]erminal [c]onfig")
--   -- keymap("n", "<localleader>rs", slime_run.send_cell, opts, "other window")
--   -- keymap("n", "<leader>rr", slime_run.send_cell, opts, "other window")
-- end

-- -------------------------------------
-- ------------------------------------- FILE TREE
-- -------------------------------------
-- if isModuleAvailable("nvim-tree") then
--   keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts, "open [e]xplorer") -- abre el navegador
if isModuleAvailable("neo-tree.nvim") then
  print("neo-tree - keys loaded")
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
if isModuleAvailable("vim-tmux-navigator.nvim") then
  print("vim-tmux-navigator - keys loaded")
  keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts, "navigate to the left window")
  keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts, "navigate to the lower window")
  keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts, "navigate to the upper window")
  keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts, "navigate to the right window")
  -- keymap("n", "<cmd>TmuxNavigatePrevious<cr>", opts, "navigate to the   window")
end

-- -------------------------------------
-- ------------------------------------- TELESCOPE
-- -------------------------------------
if isModuleAvailable("telescope.nvim") then
  print("telescope - keys loaded")
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
  keymap("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts, "find in [b]uffer (fuzzy find)")
  keymap("n", "<leader>fB", "<cmd>Telescope buffers<CR>", opts, "find [b]uffer")
  keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts, "find in [h]elp")
  keymap("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", opts, "find [q]uick fix")
  keymap("n", "<leader>vc", "<cmd>Telescope colorscheme<CR>", opts, "[v]im [c]olosrcheme")
end

-- -------------------------------------
-- ------------------------------------- LSP CONFIG
-- -------------------------------------

if isModuleAvailable("nvim-lspconfig") then
  print("nvim-lspconfig - keys loaded")
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

      -- keymap_buffer(
      --   0,
      --   "n",
      --   "<leader>la",
      --   "<cmd>lua vim.lsp.buf.code_action()<CR>",
      --   opts,
      --   "LSP -> see available code actions"
      -- ) -- show lsp implementations
      keymap_buffer(0, "v", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "[l]sp code [a]ctions") -- show lsp implementations

      keymap_buffer(0, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename() <CR>", opts, "[l]sp [r]ename in scope") -- smart rename
      keymap_buffer(
        0,
        "n",
        "<leader>ld",
        "<cmd>lua vim.diagnostic.open_float() <CR>",
        opts,
        "[l]sp [d]iagnostics (line)"
      ) -- smart rename
      keymap_buffer(
        0,
        "n",
        "<leader>lD",
        "<cmd>Telescope diagnostics bufnr=0<CR>",
        opts,
        "[l]sp [D]iagnostics (buffer)"
      ) -- show lsp implementations
      keymap_buffer(0, "n", "<leader>[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts, "lsp - prev diagnostic")
      keymap_buffer(0, "n", "<leader>]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts, "lsp - next diagnostic")

      keymap_buffer(
        0,
        "n",
        "K",
        "<cmd>lua vim.lsp.buf.hover()<CR>",
        opts,
        "LSP -> Show documentation for whatever is under cursor"
      )
      keymap_buffer(0, "n", "<leader>ls", "<cmd>LspRestart<CR>", opts, "[l]sp [s]tart/restart LSP")
    end,
  })
end

-- -------------------------------------
-- ------------------------------------- CMP
-- -------------------------------------

if isModuleAvailable("cmp-nvim-lsp") then
  print("cmp-nvim-lsp - keys loaded")
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
if isModuleAvailable("LuaSnip") then
  print("LuaSnip - keys loaded")
  local ls = require("luasnip")
  keymap("i", "<C-CR>", function()
    ls.jump(1)
  end, opts, "jump to next snippet item")
  keymap("i", "<C-l>", function()
    ls.jump(1)
  end, opts, "jump to next snippet item")
  keymap("i", "<C-h>", function()
    ls.jump(-1)
  end, opts, "jump to prev snippet item")
end

-- -------- TERMINAL
if isModuleAvailable("toggleterm.nvim") then
  print("toggleterm - keys loaded")
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
  print("harpoon - keys loaded")
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
keymap("n", "<leader>go", function()
  require("auto-pandoc").run_pandoc()
end, opts, "[g]o [o]utput PDF")

-- md-pdf
-- keymap("n", "<leader>qp", function()
--   require("md-pdf").convert_md_to_pdf()
-- end, opts, "render [p]df (md-pdf plugin)")
