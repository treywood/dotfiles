local util = require('util')
local lsp = require('util.lsp')

lsp.setup {
  name = 'ruby-lsp',
  cmd = { 'ruby-lsp' },
  root_dir = util.root_pattern { 'Gemfile' },
}
