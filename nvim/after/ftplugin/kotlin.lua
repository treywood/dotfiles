local lsp = require('util.lsp')
local util = require('util')

lsp.setup {
  name = 'kotlin-language-server',
  cmd = {
    util.devpath('kotlin-language-server-bazel-support/server/build/install/server/bin/kotlin-language-server'),
  },
  root_dir = util.root_pattern { 'WORKSPACE' },
}
