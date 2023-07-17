local util = require('util')
local lsp = require('util.lsp')

lsp.setup {
  name = 'solargraph',
  cmd = { 'solargraph', 'stdio' },
  root_dir = util.root_pattern { 'Gemfile' },
}
