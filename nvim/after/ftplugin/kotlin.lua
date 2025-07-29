local lsp = require('util.lsp')
local util = require('util')

lsp.setup {
  name = 'kotlin-language-server',
  cmd = {
    util.devpath('kotlin-lsp/kotlin-lsp.sh'),
    '--stdio',
  },
  root_dir = util.root_pattern { 'BUILD' },
  single_file_support = true,
}
