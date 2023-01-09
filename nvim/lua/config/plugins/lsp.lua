local util = require('util')

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufNewFile', 'BufReadPre' },
    dependencies = {
      {
        'jose-elias-alvarez/null-ls.nvim',
        opts = {
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
        'RRethy/vim-illuminate',
        config = function()
          require('illuminate').configure {
            filetypes_denylist = { 'NvimTree' },
          }
        end,
      },
    },
    init = function()
      vim.g.Illuminate_delay = 500
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
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },
}
