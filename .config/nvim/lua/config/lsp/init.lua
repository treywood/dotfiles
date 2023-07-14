local util = require('util')

return {
  name = 'lua-language-server',
  filetypes = { 'lua' },
  cmd = { 'lua-language-server' },
  root_dir = util.root_pattern { 'stylua.toml' },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
  format = {
    cmd = 'stylua',
    args = { '--search-parent-directories', '--stdin-filepath', '$FILENAME', '-' },
  },
}
