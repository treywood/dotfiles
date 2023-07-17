local lsp = require('util.lsp')
local format = require('util.format')
local util = require('util')

lsp.setup {
  name = 'lua-language-server',
  cmd = { 'lua-language-server' },
  root_dir = util.root_pattern { 'stylua.toml' },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
}

format.setup {
  cmd = 'stylua',
  args = { '--search-parent-directories', '--stdin-filepath', '$FILENAME', '-' },
}
