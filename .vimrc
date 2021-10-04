set nocompatible

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'haya14busa/incsearch.vim'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'thoughtbot/vim-rspec'
Plug 'fladson/vim-kitty'

Plug 'kaicataldo/material.vim'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

call plug#end()

filetype plugin indent on

" -- General Settings --
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set path=$PWD/**
set encoding=UTF-8
set laststatus=2

let mapleader = ','

syntax on
colorscheme material

let g:coc_global_extensions = ['coc-tsserver', 'coc-ember', 'coc-css', 'coc-html', 'coc-git']
let g:coc_node_path = '/Users/treyw/.nvm/versions/node/v14.4.0/bin/node'
let g:fzf_layout = { 'down': '40%' }

nnoremap <C-e> :History<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :Rg<Cr>
nnoremap <C-j> :CocList outline<CR>

let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]f <Plug>(coc-fix-current)

nmap <silent> ]g <Plug>(coc-git-nextchunk)
nmap <silent> [g <Plug>(coc-git-prevchunk)
nmap <silent> ]G <Plug>(coc-git-nextconflict)
nmap <silent> [G <Plug>(coc-git-prevconflict)
nmap <silent> gs <Plug>(coc-git-chunkinfo)

xmap <silent> af <Plug>(coc-funcobj-a)
xmap <silent> if <Plug>(coc-funcobj-i)
xmap <silent> ac <Plug>(coc-classobj-a)
xmap <silent> ic <Plug>(coc-classobj-i)

let g:material_theme_style = 'palenight'
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1

nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-m> :NERDTreeFind<CR>

map <leader>t :call RunNearestSpec()<CR>
map <leader>r :call RunLastSpec()<CR>

set statusline^=%{pathshorten(finddir('.git/..',expand('%:p:h')),5)}/%t\ [%{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}]

