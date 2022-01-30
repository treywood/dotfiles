vim.cmd "filetype plugin indent on"

vim.o.backspace='indent,eol,start'
vim.o.tabstop=2
vim.o.shiftwidth=2
vim.o.ruler=true
vim.o.number=true
vim.o.showcmd=true
vim.o.incsearch=true
vim.o.hlsearch=true
vim.o.cursorline=true
vim.o.path=os.getenv("PWD").."/**"
vim.o.encoding="UTF-8"
vim.o.completeopt="menu,menuone,noselect"
vim.o.termguicolors=true
vim.o.updatetime=100

vim.g.mapleader = ','
