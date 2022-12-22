local M = {
  'williamboman/mason.nvim',
  lazy = false,
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'jayp0521/mason-null-ls.nvim',
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
    'j-hui/fidget.nvim',
    'RRethy/vim-illuminate',
  },
}

function M.init()
  vim.g.Illuminate_delay = 500
end

function M.config()
  require('mason').setup {
    ensure_installed = { 'sumneko_lua' },
  }
  require('mason-lspconfig').setup()

  local lsp_config = require('lspconfig')
  require('mason-lspconfig').setup_handlers {
    function(server_name)
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local on_attach = function(client, bufnr)
        require('config.keymaps').setup_lsp(bufnr)
        require('illuminate').on_attach(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      local config = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }
      lsp_config[server_name].setup(config)
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
end

return M
