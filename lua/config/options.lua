local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.mouse = "a"

opt.signcolumn = "yes"

opt.cursorline = true

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.wrap = false

opt.splitbelow = true
opt.splitright = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.termguicolors = true

opt.updatetime = 250
opt.timeoutlen = 500

opt.undofile = true

opt.confirm = true

opt.clipboard = "unnamedplus"

opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
}

opt.inccommand = "split"

opt.hidden = true

vim.g.mapleader = " "
vim.g.maplocalleader = ","
