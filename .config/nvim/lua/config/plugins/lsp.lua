local util = require('util')

local M = {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    'jose-elias-alvarez/null-ls.nvim',
    'j-hui/fidget.nvim',
    'RRethy/vim-illuminate',
  },
}

function M.init()
  vim.g.Illuminate_delay = 500
  vim.diagnostic.config {
    virtual_text = false,
  }
end

function M.config()
  util.lsmod('config.lsp', function(mod)
    pcall(require, mod)
  end)

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

  require('fidget').setup {
    text = {
      spinner = 'dots_snake',
    },
  }
  require('illuminate').configure {
    filetypes_denylist = { 'NvimTree' },
  }
end

return M
