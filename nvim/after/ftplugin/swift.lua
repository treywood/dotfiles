local lsp = require('util.lsp')
local util = require('util')

lsp.setup {
  name = 'sourcekit',
  cmd = { 'sourcekit-lsp' },
  root_dir = util.root_pattern { '*.xcodeproj', '*.xcworkspace' },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
        relatedDocumentSupport = true,
      },
    },
  },
}
