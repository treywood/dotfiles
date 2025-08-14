local lsp = require('util.lsp')
local format = require('util.format')

lsp.setup {
  name = 'lua-language-server',
  cmd = { 'lua-language-server' },
  root_markers = { { 'stylua.toml' }, '.git' },
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
