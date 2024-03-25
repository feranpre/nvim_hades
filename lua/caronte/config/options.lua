vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- transparencia para la ventana principal
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- transparencia para popups

--Remap space as leader key
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = ","

-- ---------------------------------------- APPEARANCE
-- vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100" -- draw line at column x
-- vim.opt.colorcolumn = {"80","120"} -- if you want multiple  color columns
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1 -- num of lines for command line options
vim.opt.scrolloff = 8 -- keep if possible 8 lines above/below current
vim.opt.completeopt = "menuone,noinsert,noselect"

-- ---------------------------------------- TAB / Indentation
-- Algunos de estos se tocan en plugins/code/nvim-lspconfig.lua
-- OJO que si lo cambias aqui y no ves cambio es porque los está 
-- reformateando el gestor de formato de código del LSP
-- -------------------------
vim.opt.numberwidth = 4
vim.opt.tabstop = 2 -- number of spaces for tab (when printing the <TAB> char
vim.opt.softtabstop = 2 -- num spaces when you tap the tab key
vim.opt.shiftwidth = 2 -- number of spaces for each level of indentation
vim.opt.expandtab = true -- spaces instead of tabs

vim.opt.smartindent = true -- indents code "smartly"
vim.opt.wrap = false -- don't wrap lines


-- ---------------------------------------- SEARCHES
vim.opt.incsearch = true -- incremental search
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- if you start using caps include the capitalization
vim.opt.hlsearch = true -- highglight 

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.inccommand = "nosplit" -- preview incremental substitute



-- ---------------------------------------- BEHAVIOUR
vim.opt.hidden = true -- allow buffers to be "hidden" without destroying it
vim.opt.errorbells = false -- stop error sounds
vim.opt.swapfile = false -- no swapfiles
vim.opt.backup = false -- no backups
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.opt.undofile = true
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false -- don't change directories automatically
vim.opt.iskeyword:append("-") -- add "-" to what is considered a word
vim.opt.mouse:append("a") -- mouse is always an option
vim.opt.clipboard:append("unnamedplus") -- clipboard to copy in and out of vim
vim.opt.modifiable = true -- buffers are by default 'modifiable'
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
-- vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.opt.encoding = "UTF-8"
vim.opt.showmode = false


-- split window defaults
vim.opt.splitbelow = false -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

-- ---------------------------------------- FOLDS 
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99


vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.title = true
-- vim.opt.guifont = "monospace:h17"

vim.opt.spell = true
vim.opt.spelllang = { "en_us", "es_es" }

-- Jupytext --
-- vim.g.jupytext_fmt = "py"
-- vim.g.jupytext_style = 'hydrogen'

-- R color out
-- vim.g.rout_follow_colorscheme = 1
