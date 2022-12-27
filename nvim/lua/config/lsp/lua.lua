require('util.lsp').setup('sumneko_lua')

local null_ls = require('null-ls')
null_ls.register(null_ls.builtins.formatting.stylua)
