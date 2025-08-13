local lsp = require('util.lsp')
local util = require('util')

lsp.setup {
  name = 'kotlin-lsp',
  cmd = { 'kotlin-lsp', '--stdio' },
  root_dir = util.root_pattern { 'BUILD', 'build.gradle.kts' },
  single_file_support = true,
}
