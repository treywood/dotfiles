local util = require('util')
local lsp = require('util.lsp')

lsp.setup {
  name = 'tsserver',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = util.root_pattern { 'package.json' },
  init_options = { hostInfo = 'neovim' },
}
