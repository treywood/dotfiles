local util = require('util')
local lsp = require('util.lsp')
local format = require('util.format')

lsp.setup {
  name = 'gopls',
  cmd = { 'gopls' },
  root_dir = util.devpath('go/src/up'),
}

format.setup {
  name = 'gofmt',
  cmd = { 'gofmt' },
}
