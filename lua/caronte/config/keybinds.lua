local opts = { noremap = true, silent = true, desc = nil }

local keymap = require("caronte.misc.utils").keymap
local isModuleAvailable = require("caronte.misc.utils").isModuleAvailable

local wk = nil
if isModuleAvailable("which-key") then
  wk = require("which-key")
end

-- general Wichkey register
if wk ~= nil then
  wk.register({
    ["<leader>l"] = { name = "+[L]azy" },
  })
  keymap("n", "<leader>ll", "<cmd>Lazy<cr>", opts, "open [L]azy window")
  keymap("n", "<F2>", "<cmd>WhichKey<cr>", opts, "[k]eybinds - help")
  keymap("n", "<leader>k", "<cmd>WhichKey<cr>", opts, "[k]eybinds - help")
end

-- Press jk fast to enter
keymap("i", "kj", "<ESC>", opts, "exit insert mode")

keymap("n", "<ESC>", "<cmd>nohl<cr>", opts, "remove hilights")

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts, "next buffer")
keymap("n", "<S-h>", ":bprevious<CR>", opts, "previous buffer")
keymap("n", "<C-q>", ":q<CR>", opts, "[q]uit buffer")

-- save file
keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", opts, "[s]ave file")
keymap("n", "<leader>qq", "<cmd>qa<cr>", opts, "[q]uit all")

-- Uber yank --
keymap({ "n", "v" }, "<leader>y", '"+y', opts, "[y]ank out of nvim")

-- windows
if wk ~= nil then
  wk.register({
    ["<leader>w"] = { name = "+[w]indows" },
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

-- indenting
keymap("v", "<", "<gv", opts, "un-Indent selected text")
keymap("v", ">", ">gv", opts, "indent selected text")

-- -------------------------------------
-- ------------------------------------- SLIME
-- -------------------------------------
if vim.g.slime_target ~= nil then
  -- local slime_run = require("caronte.misc.slime_utils")
  wk.register({ ["<LocalLeader>s"] = { name = "+[S]end (REPL)" } })
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

-- -------------------------------------
-- ------------------------------------- FILE TREE
-- -------------------------------------
if isModuleAvailable("nvim-tree") then
  keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts, "open [e]xplorer") -- abre el navegador
else
  keymap("n", "<leader>e", ":Lex 30<CR>", opts, "open [e]xplorer") -- abre el navegador
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
    wk.register({
      ["<leader>f"] = { name = "+[f]ind (telescope)" },
    })
  end
  -- Telescope --
  -- Find files in project
  keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts, "[f]ind [f]ile")
  keymap("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", opts, "find [k]eymaps")
  keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", opts, "find [r]ecent file")
  keymap("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", opts, "find [s]tring in this dir")
  keymap("n", "<leader>fg", "<cmd>Telescope grep_string<CR>", opts, "find string under cursor in dir")
  keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts, "find [b]uffer")
  keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts, "find in [h]elp")

  -- local actions = require("telescope.actions")
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
      keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts, "LSP -> show definition references")
      keymap("n", "gD", vim.lsp.buf.declaration, opts, "LSP -> go to definition")
      keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts, "LSP -> show lsp definitions")
      keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts, "LSP -> show implementations") -- show lsp implementations
      keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts, "LSP -> show type definitions") -- show lsp implementations

      keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts, "LSP -> see available code actions") -- show lsp implementations

      keymap("n", "<leader>rn", vim.lsp.buf.rename, opts, "LSP -> smart rename") -- smart rename
      keymap("n", "<leader>d", vim.diagnostic.open_float, opts, "LSP -> show line diagnostics") -- smart rename
      keymap("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts, "LSP -> show buffer diagnostics") -- show lsp implementations
      keymap("n", "<leader>[d", vim.diagnostic.goto_prev, opts, "LSP -> go to prev diagnostic")
      keymap("n", "<leader>]d", vim.diagnostic.goto_next, opts, "LSP -> go to next diagnostic")

      keymap("n", "K", vim.lsp.buf.hover, opts, "LSP -> Show documentation for whatever is under cursor")
      -- keymap("n", "K", function()
      --   custom_lsp_hover()
      -- end, opts, "LSP -> Show documentation for whatever is under cursor")
      keymap("n", "<leader>rs", "<cmd>LspRestart<CR>", opts, "LSP -> restart LSP")
    end,
  })
end

-- ------ CMP
if isModuleAvailable("cmp") then
  local cmp = require("cmp")
  local cmp_select = { behavior = cmp.SelectBehavior.Select }
  keymap("i", "<C-p>", cmp.mapping.select_prev_item(cmp_select), opts, "[p]rev autocomplete item")
  keymap("i", "<C-n>", cmp.mapping.select_next_item(cmp_select), opts, "[n]ext autocomplete item")
  keymap("i", "<C-k>", cmp.mapping.select_prev_item(cmp_select), opts, "prev autocomplete item")
  keymap("i", "<C-j>", cmp.mapping.select_next_item(cmp_select), opts, "next autocomplete item")
  keymap("i", "<C-Space>", cmp.mapping.complete(), opts, "Complete autocomplete")
  keymap("i", "<C-e>", cmp.mapping.abort(), opts, "[e]xit autocomplete")
  keymap("i", "<C-y>", cmp.mapping.confirm({ select = true }), opts, "accept autocomplete item")
end

-- -------- QUARTO

if isModuleAvailable("quarto") then
  local quarto = require("quarto")
  if wk ~= nil then
    wk.register({
      ["<leader>q"] = {
        name = "+[q]uarto",
        a = { ":QuartoActivate<cr>", "[a]ctivate" },
        p = { ":lua require'quarto'.quartoPreview()<cr>", "[p]review" },
        q = { ":lua require'quarto'.quartoClosePreview()<cr>", "[q]uiet preview" },
        h = { ":QuartoHelp ", "[h]elp" },
        r = {
          name = "[r]un",
          r = { ":QuartoSendAbove<cr>", "to cu[r]sor" },
          a = { ":QuartoSendAll<cr>", "run [a]ll" },
          b = { ":QuartoSendBelow<cr>", "run [b]elow" },
        },
        e = { require("otter").export, "[e]xport" },
        E = {
          function()
            require("otter").export(true)
          end,
          "[E]xport with overwrite",
        },
      },
    })
  end
end

-- -------- TERMINAL
if isModuleAvailable("toggleterm") then
  local term = require("toggleterm")
  if wk ~= nil then
    wk.register({
      ["<leader>t"] = { name = "[t]erminal" },
    })
  end
  keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", opts, "[t]oggle [t]erm")
  keymap("n", "<leader>tr", "<cmd>vsplit term://R<cr>", opts, "new [r] terminal")
end
