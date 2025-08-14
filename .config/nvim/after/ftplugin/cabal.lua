local lsp = require('util.lsp')

vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

lsp.setup {
  name = 'hls',
  cmd = { 'haskell-language-server-wrapper', '--lsp' },
  root_markers = { { '*.cabal' }, '.git' },
}
