--vim.o.nocompatible=true

require('plugins')
require('options')
require('theme')
require('keymaps').setup_keymaps()
require('lsp')

vim.g.fzf_layout = { down = '40%' }

vim.cmd [[
  augroup fmt
    autocmd!
    au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  augroup END
  let g:neoformat_enabled_haskell = ['hfmt']
  let g:neoformat_enabled_ruby = []
]]

