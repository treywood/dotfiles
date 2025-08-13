local lsp = require('util.lsp')
local format = require('util.format')
local util = require('util')

vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

lsp.setup {
  name = 'hls',
  cmd = { 'haskell-language-server-wrapper', '--lsp' },
  root_markers = { { '*.cabal' }, '.git' },
}

format.setup {
  name = 'fourmolu',
  cmd = { 'fourmolu', '--stdin-input-file', '$FILENAME', '--quiet' },
}
