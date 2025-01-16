local live_multigrep = require("hades.utils.telescope_multigrep").live_multigrep
local keymap = require("hades.utils.keys").keymap
local keymap_buffer = require("hades.utils.keys").keymap_buffer
local key_or_clue = require("hades.utils.keys").key_or_clue

local opts = { noremap = true, silent = true, desc = nil }

--
-- TELESCOPE
--
if IsModuleAvailable("telescope") then
  if DEBUG then
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
  if DEBUG then
    print("telescope NOT DETECTED")
  end
end

--
-- OIL
--
if IsModuleAvailable("oil") then
  keymap("n", "<leader>e", "<cmd>Oil<CR>", opts, "[e]xplore with Oil current directory")
end

--
-- TODO-COMMENTS
--
if IsModuleAvailable("todo-comments") then
  if IsModuleAvailable("telescope") then
    keymap("n", "<leader>ft", "<cmd>TodoTelescope<CR>", opts, "[f]ind TODO tags (telescope)")
  else
    keymap("n", "<leader>ft", "<cmd>TodoLocList<CR>", opts, "[f]ind TODO tags (NO telescope)")
  end
end

--
-- SNACKS
--
if IsModuleAvailable("snacks") then
  -- print("Snacks detected")
  keymap("n", "<leader>n", "<cmd>lua Snacks.notifier.show_history()<CR>", opts, "[n]otifier history")
  keymap("n", "<leader>bd", "<cmd>lua Snacks.bufdelete()<CR>", opts, "[b]uffer [d]elete")
  keymap("n", "<leader>bD", "<cmd>lua Snacks.bufdelete.other()<CR>", opts, "[b]uffer [D]elete others")
end

--
-- R
--
-- if isModuleAvailable("r") then
--   if debug then
--     print("R.nvim - keys loaded")
--   end
--   require("hades.config.keybinds_r")
-- end

--
-- QUARTO
--
if IsModuleAvailable("quarto") then
  if DEBUG then
    print("Quarto - keys loaded")
  end
  require("hades.config.keybinds_quarto")
else
  if DEBUG then
    print("Quarto - keys NOT loaded")
  end
end

-- keymap("n", "<leader>qp", "<cmd>lua require('quarto').quartoPreview()<CR>", opts, "[q]uarto [p]review")
-- keymap("n", "<leader>qc", "<cmd>lua require('quarto').quartoClosePreview()<CR>", opts, "[q]uarto [c]lose preview")

--
-- HARPOON
--

if IsModuleAvailable("harpoon") then
  if DEBUG then
    print("harpoon - keys loaded")
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
else
  if DEBUG then
    print("harpoon - NOT DETECTED")
  end
end

--
-- nvim-python-repl
--
if IsModuleAvailable("nvim-python-repl") then
  if DEBUG then
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
  if DEBUG then
    print("nvim-python-repl - keys NOT loaded")
  end
end

--
-- TMUX NAV
--
if IsModuleAvailable("TmuxNavigateDown") then
  if DEBUG then
    print("vim-tmux-navigator - keys loaded")
  end
  keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts, "navigate to the left window")
  keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts, "navigate to the lower window")
  keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts, "navigate to the upper window")
  keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts, "navigate to the right window")
  -- keymap("n", "<cmd>TmuxNavigatePrevious<cr>", opts, "navigate to the   window")
else
  if DEBUG then
    print("vim-tmux-navigator NOT DETECTED - default keys loaded")
  end
  keymap("n", "<C-h>", "<C-w>h", opts, "navigate to the left window")
  keymap("n", "<C-j>", "<C-w>j", opts, "navigate to the lower window")
  keymap("n", "<C-k>", "<C-w>k", opts, "navigate to the upper window")
  keymap("n", "<C-l>", "<C-w>l", opts, "navigate to the right window")
end

--
-- LSP CONFIG
--

if IsModuleAvailable("lspconfig") then
  if DEBUG then
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
      keymap_buffer(0, "n", "grn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "LSP -> rename in scope")          -- show lsp implementations
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
      keymap_buffer(0, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts, "LSP -> show implementations")   -- show lsp implementations
      keymap_buffer(0, "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts, "LSP -> show type definitions") -- show lsp implementations

      -- help
      keymap_buffer(0, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts, "LSP -> Doc for string under cursor")

      -- restgart
      keymap_buffer(0, "n", "<leader>ls", "<cmd>LspRestart<CR>", opts, "[l]sp [s]tart/restart LSP")
    end,
  })
else
  if DEBUG then
    print("nvim-lspconfig - NOT keys loaded")
  end
end

--
-- TROUBLE
--
if IsModuleAvailable("trouble") then
  if DEBUG then
    print("trouble - keys loaded")
  end
  local trouble = require("trouble")
  local function next()
    trouble.next({ skip_groups = true, jump = true })
  end
  local function previous()
    trouble.previous({ skip_groups = true, jump = true })
  end

  keymap("n", "]t", next, opts, "next [t]rouble item")
  keymap("n", "[t", previous, opts, "previous [t]rouble item")
else
  if DEBUG then
    print("trouble NOT DETECTED")
  end
end

--
-- CONFORM
--
if IsModuleAvailable("conform") then
  if DEBUG then
    print("conform - keys loaded")
  end
  local conform = require("conform")

  keymap("n", "<leader>cf", conform.format, opts, "[c]onform [f]ormat file")
else
  if DEBUG then
    print("trouble NOT DETECTED")
  end
end
