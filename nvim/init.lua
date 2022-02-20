--vim.o.nocompatible=true

require'plugins'
require'options'
require'theme'
require'keymaps'.setup_keymaps()
require'lsp'

vim.cmd [[
  augroup startup
    autocmd!
    au VimEnter * NeorgStart silent=true
  augroup END
]]

