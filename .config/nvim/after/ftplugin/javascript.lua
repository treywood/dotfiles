local util = require('util')
local lsp = require('util.lsp')

lsp.setup {
  name = 'tsserver',
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { { 'package.json' }, '.git' },
  init_options = { hostInfo = 'neovim' },
}
