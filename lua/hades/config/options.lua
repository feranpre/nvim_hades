
if DEBUG then
  print("   -- loaded options")
end




vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- transparencia para la ventana principal
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- transparencia para popups

-- ---------------------------------------- APPEARANCE
-- vim.opt.guicursor = ''
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100" -- draw line at column x
-- vim.opt.colorcolumn = {'80','120'} -- if you want multiple  color columns
vim.opt.cursorline = true
vim.opt.signcolumn = "yes" -- column for icons for LSP and things like that, marks, folds,...
vim.opt.cmdheight = 1 -- num of lines for command line options
vim.opt.scrolloff = 8 -- keep if possible 8 lines above/below current
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.numberwidth = 3

-- ---------------------------------------- TAB / Indentation
-- Algunos de estos se tocan en plugins/code/nvim-lspconfig.lua
-- OJO que si lo cambias aqui y no ves cambio es porque los está
-- reformateando el gestor de formato de código del LSP
-- -------------------------
vim.opt.tabstop = 4 -- number of spaces for tab (when printing the <TAB> char
vim.opt.softtabstop = 4 -- num spaces when you tap the tab key
vim.opt.shiftwidth = 4 -- number of spaces for each level of indentation
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.smarttab = true -- detects that the "space" is a tab and removes all


vim.opt.smartindent = true -- indents code 'smartly'
vim.opt.autoindent = true -- tries to auto-indent the file
vim.opt.breakindent = true -- breaks indentation when line goes over the max length

vim.opt.wrap = false -- don't wrap lines
vim.opt.formatoptions = "cqrnjt"
-- vim.opt.formatoptions = "cqrnj"

-- ---------------------------------------- LIST CHARACTERS
vim.opt.list = true -- show some "invisible" characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } 


-- ---------------------------------------- SEARCHES
vim.opt.incsearch = true -- incremental search
vim.opt.ignorecase = true -- ignore case
vim.opt.smartcase = true -- if you start using caps include the capitalization
vim.opt.hlsearch = true -- highglight

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.inccommand = "nosplit" -- preview incremental substitute

-- ---------------------------------------- BEHAVIOUR
vim.opt.hidden = true -- allow buffers to be 'hidden' without destroying it
vim.opt.errorbells = false -- stop error sounds
vim.opt.swapfile = false -- no swapfiles
vim.opt.backup = false -- no backups
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.opt.undofile = true
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false -- don't change directories automatically
vim.opt.iskeyword:append("-") -- add '-' to what is considered a word
vim.opt.mouse:append("a") -- mouse is always an option
vim.opt.clipboard:append("unnamedplus") -- clipboard to copy in and out of vim
vim.opt.modifiable = true -- buffers are by default 'modifiable'
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.guicursor =
  "n-v-c:block,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
-- vim.opt.guicursor = 'n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
vim.opt.encoding = "UTF-8"
vim.opt.showmode = false -- that's for the status-line plugin of choice

-- split window defaults
vim.opt.splitright = true -- put new windows right of current
vim.opt.splitbelow = true -- put new windows below current

-- ---------------------------------------- FOLDS

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.foldtext = ""
-- vim.opt.foldtext = "v:lua require('hades.utils.utils').fold_current_line()"
-- vim.opt.foldtext = "v:lua.require('hades.utils.folds').my_fold_text()"

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.title = true
-- vim.opt.guifont = 'monospace:h17'

-- ---------------------------------------- TEXT
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "es_es" }
vim.opt.textwidth = 80

-- vim.opt.textwidth = 120

-- Jupytext --
-- vim.g.jupytext_fmt = 'py'
-- vim.g.jupytext_style = 'hydrogen'

-- R color out
-- vim.g.rout_follow_colorscheme = 1
