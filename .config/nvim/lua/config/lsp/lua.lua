local null_ls = require('null-ls')

require('config.lsp.util').setup('sumneko_lua')
null_ls.register(null_ls.builtins.formatting.stylua)
