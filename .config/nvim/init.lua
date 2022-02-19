--vim.o.nocompatible=true

require'plugins'
require'options'
require'theme'
require'keymaps'.setup_keymaps()
require'lsp'

vim.cmd [[
  command Notes e ~/notes/index.norg

  augroup neorg
    autocmd!
    au VimEnter * NeorgStart silent=true
  augroup END
]]

