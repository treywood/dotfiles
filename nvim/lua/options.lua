local util = require'util'

vim.cmd "filetype plugin indent on"

vim.o.backspace='indent,eol,start'

vim.o.tabstop=2
vim.o.shiftwidth=2
vim.o.expandtab=true

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

vim.o.cursorline = false
util.augroups {
  nvimtree_cursorline = {
    'FileType NvimTree au BufEnter <buffer> setlocal cursorline',
  }
}

vim.wo.foldmethod="expr"
vim.wo.foldexpr="nvim_treesitter#foldexpr()"
vim.o.foldlevelstart=99

vim.g.mapleader = ','
