-- get Hades basic config
Hades = require("hades.config.hades")
DEBUG = true

vim.g.mapleader = Hades.leader
vim.g.maplocalleader = Hades.localleader

IsModuleAvailable = require("hades.utils.module_available").isModuleAvailable

require("hades.lazy")

require("hades.config.options")

require("lazy").setup({
  -- { import = "hades.plugins.lsp" },
  { import = "hades.plugins.code" },
  { import = "hades.plugins.editor" },
  { import = "hades.plugins.colorschemes" },
  { import = "hades.plugins.markdown" },
  { import = "hades.plugins.repl" },
})

require("hades.config.keybinds")
require("hades.config.keybinds_plugins")
require("hades.config.lsp")
require("hades.utils.autocmd_filetype")
require("hades.utils.markdown")
require("hades.utils.lsp_code_blocks")

vim.cmd.colorscheme(Hades.colorscheme)

vim.g.R_filetypes = { "r", "rmd", "rnoweb", "quarto", "rhelp", "markdown" }

-- Helper: fold/unfold all mkdnflow sections at level `lvl` (and deeper)
function _G.MkdnFoldAllAtLevel(lvl, action)
  -- Recompute folds (in case document changed)
  pcall(vim.cmd, "silent! normal! zx")

  local total = vim.fn.line("$")
  local ln = 1
  local targets = {}
  while ln <= total do
    local line = vim.fn.getline(ln)
    -- match a heading of exactly this level
    local hashes = line:match("^(#+)%s")
    if hashes and #hashes == lvl then
      table.insert(targets, ln)
    end
    ln = ln + 1
  end

  if #targets == 0 then
    print("No level " .. lvl .. " headings found.")
    return
  end

  for _, hln in ipairs(targets) do
    if action == "close" then
      vim.cmd(hln .. "MkdnFoldSection")
    elseif action == "open" then
      vim.cmd(hln .. "MkdnUnfoldSection")
    elseif action == "toggle" then
      -- You might check fold status at hln, but simplest is toggle
      vim.cmd(hln .. "MkdnFoldSection")
    end
  end
end

-- Exposed toggles
function _G.ToggleFoldMkdnLevel2()
  _G.MkdnFoldAllAtLevel(2, "close")
end
function _G.ToggleFoldMkdnLevel3()
  _G.MkdnFoldAllAtLevel(3, "close")
end
function _G.ToggleFoldMkdnLevel4()
  _G.MkdnFoldAllAtLevel(4, "close")
end

-- Or if you prefer toggle/unfold, you can define open versions too
function _G.OpenFoldMkdnLevel2()
  _G.MkdnFoldAllAtLevel(2, "open")
end
function _G.OpenFoldMkdnLevel3()
  _G.MkdnFoldAllAtLevel(3, "open")
end
function _G.OpenFoldMkdnLevel4()
  _G.MkdnFoldAllAtLevel(4, "open")
end

vim.keymap.set("n", "<leader>F2", ToggleFoldMkdnLevel2, { desc = "Fold all level-2 (and deeper) sections" })
vim.keymap.set("n", "<leader>F3", ToggleFoldMkdnLevel3, { desc = "Fold all level-3 sections" })
vim.keymap.set("n", "<leader>F4", ToggleFoldMkdnLevel4, { desc = "Fold all level-4 sections" })

vim.keymap.set("n", "<leader>O2", OpenFoldMkdnLevel2, { desc = "Open all level-2 sections" })
vim.keymap.set("n", "<leader>O3", OpenFoldMkdnLevel3, { desc = "Open all level-3 sections" })
vim.keymap.set("n", "<leader>O4", OpenFoldMkdnLevel4, { desc = "Open all level-4 sections" })
