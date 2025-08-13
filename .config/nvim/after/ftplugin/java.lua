local util = require('util')
local lsp = require('util.lsp')

lsp.setup {
  name = 'java-language-server',
  cmd = { util.devpath('java-language-server/dist/lang_server_mac.sh') },
  root_markers = { { 'BUILD' }, '.git' },
  capabilities = {
    dynamicRegistration = false,
  },
}
