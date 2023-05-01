local util = require('util')

return {
  name = 'lua-language-server',
  filetypes = { 'lua' },
  cmd = { 'lua-language-server' },
  root_dir = util.root_pattern { 'stylua.toml' },
  formatter = 'stylua',
}
