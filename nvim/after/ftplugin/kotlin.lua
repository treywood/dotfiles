local lsp = require('util.lsp')

lsp.setup {
  name = 'kotlin-lsp',
  cmd = { 'kotlin-lsp', '--stdio' },
  root_markers = {
    {
      'BUILD',
      'settings.gradle',
      'settings.gradle.kts',
      'build.gradle',
      'build.gradle.kts',
    },
    '.git',
  },
  single_file_support = true,
}
