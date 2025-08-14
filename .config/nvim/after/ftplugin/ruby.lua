local lsp = require('util.lsp')

lsp.setup {
  name = 'ruby-lsp',
  cmd = { 'ruby-lsp' },
  root_markers = { { 'Gemfile' }, '.git' },
  init_options = {
    enabledFeatures = {
      semanticHighlighting = false,
    },
  },
}
