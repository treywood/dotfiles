local null_ls = require('null-ls')
local helpers = require('null-ls.helpers')

local formatter_stylish_haskell = {
  name = 'stylish-haskell',
  filetypes = { 'haskell' },
  method = null_ls.methods.FORMATTING,
  generator = helpers.formatter_factory {
    command = 'stylish-haskell',
    to_stdin = true,
    from_stderr = true,
  },
}

local formatter_scalariform = {
  name = 'scalariform',
  filetypes = { 'scala', 'sbt' },
  method = null_ls.methods.FORMATTING,
  generator = helpers.formatter_factory {
    command = 'scalariform',
    args = { '--stdin' },
    to_stdin = true,
  },
}

local formatter_hackfmt = {
  name = 'hackfmt',
  filetypes = { 'hack', 'php' },
  method = null_ls.methods.FORMATTING,
  generator = helpers.formatter_factory {
    command = 'hackfmt',
    to_stdin = true,
  },
}

return {
  -- formatters
  null_ls.builtins.formatting.rufo,
  null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.formatting.elm_format,
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.gofmt,
  formatter_hackfmt,
  formatter_stylish_haskell,
  formatter_scalariform,
}
