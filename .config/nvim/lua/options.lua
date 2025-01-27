local opt = vim.opt -- normal way to access options, syntactic sugar
local o = vim.o -- same thing, less syntactic sugar
local g = vim.g -- globals

-- globals --
g.mapleader = " "
g.maplocalleader = ","

--opt.clipboard = "unnamedplus" -- map clipboard to OS lvl
opt.cursorline = true -- set a line under line w cursor

opt.showtabline = 2 -- always show file tab line

-- tab behavior
opt.expandtab = true -- spaces
opt.shiftwidth = 4 -- TODO: vim-sleuth might make this redundant???
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
--opt.fillchars = { eob = " " } -- replace ~ at eof of buffer with nothing AKA spaces

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a" -- enable mouse support everywhere

opt.number = true
opt.relativenumber = true
opt.numberwidth = 2

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true

opt.list = true
-- TODO: maybe setup listchars

-- TODO: vim.diagnostic.config ???


