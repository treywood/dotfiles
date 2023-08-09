local lsp = require('util.lsp')
local util = require('util')

lsp.setup {
  name = 'kotlin-language-server',
  cmd = { 'kotlin-language-server' },
  root_dir = util.root_pattern { 'build.gradle' },
}
