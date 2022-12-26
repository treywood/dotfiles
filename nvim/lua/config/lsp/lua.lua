local null_ls = require('null-ls')

require('util.lsp').setup('sumneko_lua')
null_ls.register(null_ls.builtins.formatting.stylua)
