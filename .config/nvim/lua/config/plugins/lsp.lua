local util = require('util')

return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    init = function()
      vim.diagnostic.config {
        virtual_text = false,
      }
    end,
    config = function()
      util.lsmod('config.lsp', function(mod)
        pcall(require, mod)
      end)
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'VeryLazy',
    config = {
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
    },
  },
  {
    'nvim-lua/lsp-status.nvim',
    config = function()
      require('lsp-status').config {
        current_function = false,
        status_symbol = '',
      }
      require('lsp-status').register_progress()
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    event = 'VeryLazy',
    config = true,
  },
  {
    'RRethy/vim-illuminate',
    event = 'VeryLazy',
    init = function()
      vim.g.Illuminate_delay = 500
    end,
    config = function()
      require('illuminate').configure {
        filetypes_denylist = { 'NvimTree' },
      }
    end,
  },
}
