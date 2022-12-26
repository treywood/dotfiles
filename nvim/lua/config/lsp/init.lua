local util = require('config.lsp.util')

require('mason-lspconfig').setup_handlers {
  function(server_name)
    util.setup(server_name)
  end,
}

require('mason-null-ls').setup {
  ensure_installed = { 'stylua' },
  automatic_setup = true,
}
require('null-ls').setup {
  debug = true,
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end
  end,
}
require('mason-null-ls').setup_handlers()

require('fidget').setup {
  text = {
    spinner = 'dots_snake',
  },
}

require('illuminate').configure {
  filetypes_denylist = { 'NvimTree' },
}
