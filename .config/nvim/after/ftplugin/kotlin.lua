local lsp = require('util.lsp')
local util = require('util')

lsp.setup {
  name = 'kotlin-lsp',
  cmd = { 'kotlin-lsp', '--stdio' },
  root_markers = { { 'BUILD', 'build.gradle.kts', 'build.gradle' }, '.git' },
  single_file_support = true,
}
