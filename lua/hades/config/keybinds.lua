-- TODO: limpiar comentarios
local live_multigrep = require("hades.misc.telescope_multigrep").live_multigrep

local keymap = require("hades.misc.utils").keymap
local keymap_buffer = require("hades.misc.utils").keymap_buffer
local key_or_clue = require("hades.misc.utils").key_or_clue
local isModuleAvailable = require("hades.misc.utils").isModuleAvailable

local debug = true
local opts = { noremap = true, silent = true, desc = nil }

-- local keymap = require("hades.misc.utils").keymap
-- local keymap_buffer = require("hades.misc.utils").keymap_buffer
-- local isModuleAvailable = require("hades.misc.utils").isModuleAvailable
-- local isAvailable = require("hades.misc.utils").isAvailable

if debug then
  print("Loading keys")
end

keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts, "open [L]azy window")

-- local generate_html_from_rscript = require("hades.misc.utils").generate_html_from_rscript
-- Define the function to call the pandoc2pdf.py script
-- keymap("n", "<leader>p", "<cmd>lua PandocToPDF()<CR>", opts, "pdf")

keymap("n", "<leader><leader>x", "<cmd>source %<cr>", opts, "e[x]ecute fiel (source)")

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

-- window creation
key_or_clue("n", "<leader>w", "+[w]indow options")
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
-- key_or_clue("n", "<leader>b", "+[b]uffer options")
-- keymap("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", opts, "[b]uffer [d]elete")
-- keymap("n", "<leader>bD", "<cmd>%bd|e#<CR>", opts, "[b]uffer [D]elete all but current")

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
-- keymap("n", "zG", "zG", opts, "[G]ood word to add to internal dictionary (spelling)")
keymap("n", "zug", "zug", opts, "[u]ndo add [g]ood word to dictionary (spelling)")
-- keymap("n", "zuG", "zuG", opts, "[u]ndo add [G]ood word to internal dictionary (spelling)")
keymap("n", "zw", "zw", opts, "[w]rong word to add to dictionary (spelling)")
-- keymap("n", "zW", "zW", opts, "[W]rong word to add to internal dictionary (spelling)")
-- keymap("n", "z=", "z=", opts, "check possible replacements for word (spelling)") -- IN TELESCOPE

-- -------------------------------------
-- ------------------------------------- TMUX NAV
-- -------------------------------------
if isModuleAvailable("TmuxNavigateDown") then
  if debug then
    print("vim-tmux-navigator - keys loaded")
  end
  keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts, "navigate to the left window")
  keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts, "navigate to the lower window")
  keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts, "navigate to the upper window")
  keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts, "navigate to the right window")
  -- keymap("n", "<cmd>TmuxNavigatePrevious<cr>", opts, "navigate to the   window")
else
  if debug then
    print("vim-tmux-navigator NOT DETECTED - default keys loaded")
  end
  keymap("n", "<C-h>", "<C-w>h", opts, "navigate to the left window")
  keymap("n", "<C-j>", "<C-w>j", opts, "navigate to the lower window")
  keymap("n", "<C-k>", "<C-w>k", opts, "navigate to the upper window")
  keymap("n", "<C-l>", "<C-w>l", opts, "navigate to the right window")
end

-- -------------------------------------
-- ------------------------------------- TELESCOPE
-- -------------------------------------
if isModuleAvailable("telescope") then
  if debug then
    print("telescope - keys loaded")
  end
  key_or_clue("n", "<leader>f", "+[f]ind (telescope)")

  -- Telescope --
  -- Find files in project
  keymap("n", "<leader>ff", require("telescope.builtin").find_files, opts, "[f]ind [f]ile")
  keymap("n", "<leader>fk", require("telescope.builtin").keymaps, opts, "[f]ind [k]eymaps")
  keymap("n", "<leader>fr", require("telescope.builtin").oldfiles, opts, "[f]ind [r]ecent file")
  keymap("n", "<leader>fg", live_multigrep, opts, "[f]ind string in this [d]ir")
  keymap("n", "<leader>fs", require("telescope.builtin").grep_string, opts, "[f]ind string under cursor in dir")
  keymap(
    "n",
    "<leader>fb",
    require("telescope.builtin").current_buffer_fuzzy_find,
    opts,
    "[f]ind in [b]uffer (fuzzy find)"
  )
  keymap("n", "<leader>fB", require("telescope.builtin").buffers, opts, "[f]ind [b]uffer")
  keymap("n", "<leader>fh", require("telescope.builtin").help_tags, opts, "[f]ind in [h]elp")
  keymap("n", "<leader>fq", require("telescope.builtin").quickfix, opts, "[f]ind [q]uick fix")
  keymap("n", "<leader>vc", require("telescope.builtin").colorscheme, opts, "[v]im [c]olosrcheme")
  keymap("n", "<leader>fc", function()
    require("telescope.builtin").find_files({
      cwd = vim.fn.stdpath("config"),
    })
  end, opts, "[f]ind nvim [c]onfig file")

  keymap("n", "z=", require("telescope.builtin").spell_suggest, opts, "[f]ind [b]uffer")
else
  keymap("n", "z=", "z=", opts, "check possible replacements for word (spelling)")
end

-- -------------------------------------
-- ------------------------------------- LSP CONFIG
-- -------------------------------------

if isModuleAvailable("lspconfig") then
  if debug then
    print("nvim-lspconfig - keys loaded")
  end
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      -- local opts = { buffer = ev.buf }

      -- references
      keymap_buffer(0, "n", "gR", "<cmd>Telescope lsp_references<CR>", opts, "LSP -> show definition references")
      keymap_buffer(0, "n", "grr", "<cmd>lua vim.lsp.buf.references()<CR>", opts, "LSP -> show references") -- show lsp implementations

      -- rename
      keymap_buffer(0, "n", "grn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "LSP -> rename in scope") -- show lsp implementations
      keymap_buffer(0, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename() <CR>", opts, "[l]sp [r]ename in scope") -- smart rename

      -- diagnostics
      keymap_buffer(
        0,
        "n",
        "<leader>ld",
        "<cmd>lua vim.diagnostic.open_float() <CR>",
        opts,
        "[l]sp [d]iagnostics (line)"
      )
      keymap_buffer(
        0,
        "n",
        "<leader>lD",
        "<cmd>Telescope diagnostics bufnr=0<CR>",
        opts,
        "[l]sp [D]iagnostics (buffer)"
      ) -- show lsp implementations

      -- move through diagnostic
      keymap_buffer(0, "n", "<M-j>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts, "lsp - prev diagnostic")
      keymap_buffer(0, "n", "<M-k>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts, "lsp - next diagnostic")
      -- keymap_buffer(0, "n", "<leader>[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts, "lsp - prev diagnostic")
      -- keymap_buffer(0, "n", "<leader>]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts, "lsp - next diagnostic")

      -- actions
      keymap_buffer(0, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "[l]sp code [a]ctions") -- show lsp implementations
      keymap_buffer(0, "v", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "[l]sp code [a]ctions") -- show lsp implementations

      -- definitions and lsp_implementations
      keymap_buffer(0, "n", "gD", "<cmd>lua vim.lsp.buf.declaration() <CR>", opts, "LSP -> go to definition")
      keymap_buffer(0, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts, "LSP -> show lsp definitions")
      keymap_buffer(0, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts, "LSP -> show implementations") -- show lsp implementations
      keymap_buffer(0, "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts, "LSP -> show type definitions") -- show lsp implementations

      -- help
      keymap_buffer(0, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts, "LSP -> Doc for string under cursor")

      -- restgart
      keymap_buffer(0, "n", "<leader>ls", "<cmd>LspRestart<CR>", opts, "[l]sp [s]tart/restart LSP")
    end,
  })
end

--
-- OIL
--
if isModuleAvailable("oil") then
  keymap("n", "<leader>e", "<cmd>Oil<CR>", opts, "[e]xplore with Oil current directory")
end

--
-- TODO-COMMENTS
--
if isModuleAvailable("todo-comments") then
  keymap("n", "<leader>ft", "<cmd>TodoTelescope<CR>", opts, "[f]ind TODO tags (telescope)")
end

--
-- SNACKS
--
if isModuleAvailable("snacks") then
  print("Snacks detected")
  keymap("n", "<leader>n", "<cmd>lua Snacks.notifier.show_history()<CR>", opts, "[n]otifier history")
  keymap("n", "<leader>bd", "<cmd>lua Snacks.bufdelete()<CR>", opts, "[b]uffer [d]elete")
  keymap("n", "<leader>bD", "<cmd>lua Snacks.bufdelete.other()<CR>", opts, "[b]uffer [D]elete others")
end

--
-- R
--
if isModuleAvailable("r") then
  if debug then
    print("R.nvim - keys loaded")
  end
  require("hades.config.keybinds_r")
end

--
-- QUARTO
--
if isModuleAvailable("quarto") then
  if debug then
    print("Quarto - keys loaded")
  end
  require("hades.config.keybinds_quarto")
else
  if debug then
    print("Quarto - keys NOT loaded")
  end
end

-- keymap("n", "<leader>qp", "<cmd>lua require('quarto').quartoPreview()<CR>", opts, "[q]uarto [p]review")
-- keymap("n", "<leader>qc", "<cmd>lua require('quarto').quartoClosePreview()<CR>", opts, "[q]uarto [c]lose preview")

--
-- MOLTEN
--
if isModuleAvailable("MoltenInfo") then
  if debug then
    print("Molten - keys loaded")
  end
  require("hades.config.keybinds_molten")
else
  if debug then
    print("Molten - keys NOT loaded")
  end
end

--
-- SLIME
--
if isModuleAvailable("SlimeConfig") then
  if debug then
    print("Slime - keys loaded")
  end
  require("hades.config.keybinds_slime")
else
  if debug then
    print("Slime - keys NOT loaded")
  end
end

--
-- HARPOON
--

if isModuleAvailable("harpoon") then
  if debug then
    print("harpoon - keys loaded")
  else
    print("harpoon - NOT detected")
  end
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

--
-- nvim-python-repl
--
if isModuleAvailable("nvim-python-repl") then
  if debug then
    print("nvim-python-repl - keys loaded")
  end

  keymap("n", "<C-CR>", function()
    require("nvim-python-repl").send_statement_definition()
  end, opts, "Send semantic unit to REPL")

  keymap("v", "<localleader>sr", function()
    require("nvim-python-repl").send_visual_to_repl()
  end, opts, "Send visual selection to REPL")

  keymap("n", "<localleader>sc", function()
    require("nvim-python-repl").send_current_cell_to_repl()
  end, opts, "Send current cell to REPL")

  keymap("n", "<localleader>sf", function()
    require("nvim-python-repl").send_buffer_to_repl()
  end, opts, "Send entire buffer to REPL")

  keymap("n", "<localleader>se", function()
    require("nvim-python-repl").toggle_execute()
  end, opts, "Automatically execute command in REPL after sent")

  -- keymap("n", "<localleader>tn", function()
  --   require("nvim-python-repl").toggle_vertical()
  -- end, opts, "Create REPL in vertical or horizontal split")

  keymap("n", "<localleader>tn", function()
    require("nvim-python-repl").open_repl()
  end, opts, "[t]erminal [n]ew")
else
  if debug then
    print("nvim-python-repl - keys NOT loaded")
  end
end
