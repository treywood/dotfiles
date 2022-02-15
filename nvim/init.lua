--vim.o.nocompatible=true

require'plugins'
require'options'
require'theme'
require'keymaps'.setup_keymaps()
require'lsp'

vim.cmd [[
  augroup fmt
    autocmd!
    au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  augroup END
  let g:neoformat_enabled_haskell = ['hfmt']
  let g:neoformat_enabled_ruby = []

  command Notes e ~/notes/index.norg

  augroup neorg
    autocmd!
    au VimEnter * NeorgStart silent=true
  augroup END
]]

