local util = require('util')
local lsp = require('util.lsp')
local format = require('util.format')

lsp.setup {
  name = 'rust_analyzer',
  cmd = { 'rust-analyzer' },
  root_dir = util.root_pattern { 'Cargo.toml' },
}

format.setup {
  cmd = 'rustfmt',
}
