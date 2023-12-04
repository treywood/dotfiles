local lsp = require('util.lsp')
local util = require('util')

vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

lsp.setup {
  name = 'hls',
  cmd = { 'haskell-language-server-wrapper', '--lsp' },
  root_dir = util.root_pattern { '*.cabal' },
}
