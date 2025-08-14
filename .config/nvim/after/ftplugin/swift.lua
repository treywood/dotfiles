local lsp = require('util.lsp')

lsp.setup {
  name = 'sourcekit',
  cmd = { 'sourcekit-lsp' },
  root_markers = { { '*.xcodeproj', '*.xcworkspace' }, '.git' },
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
