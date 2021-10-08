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

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

Plug 'kaicataldo/material.vim'
Plug 'rbong/vim-crystalline'

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
set fillchars+=stl:\ ,stlnc:\ "

autocmd FileType html.handlebars setlocal nofixendofline

let mapleader = ','

syntax on
colorscheme material

function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %f%h%w%m%r '
  if a:current
    let l:s .= crystalline#right_sep('', 'Fill') . '  %{fugitive#head()}'
  endif

  let l:s .= '%='
  if a:current
    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#left_mode_sep('')
  endif
  if a:width > 80
    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! TabLine()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'onedark'

set showtabline=2
set guioptions-=e
set laststatus=2
set background=dark
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

