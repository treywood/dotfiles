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
  name = 'stylua',
  cmd = { 'stylua', '--search-parent-directories', '--stdin-filepath', '$FILENAME', '-' },
  test = function()
    local test = vim.fs.find({ 'stylua.toml' }, { upward = true, path = vim.fn.expand('%:p:h') })
    return #test > 0
  end,
}
