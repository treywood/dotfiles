(vim.cmd "filetype plugin indent on")
(vim.cmd "set mouse=")

(set vim.o.backspace "indent,eol,start")

(set vim.o.tabstop 2)
(set vim.o.shiftwidth 2)
(set vim.o.expandtab true)

(set vim.o.ruler true)
(set vim.o.number true)
(set vim.o.showcmd true)
(set vim.o.incsearch true)
(set vim.o.hlsearch true)
(set vim.o.path (.. (os.getenv :PWD) "/**"))
(set vim.o.encoding :UTF-8)
(set vim.o.completeopt "menu,menuone,noselect")
(set vim.o.termguicolors true)
(set vim.o.updatetime 100)
(set vim.o.cursorline false)
(set vim.o.splitright true)

(set vim.wo.foldmethod :expr)
(set vim.wo.foldexpr "nvim_treesitter#foldexpr()")
(set vim.o.foldlevelstart 99)

(set vim.o.lazyredraw true)

(set vim.g.mapleader ",")
