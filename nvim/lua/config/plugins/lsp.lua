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

  local util = require('util')
  util.lsmod('config.lsp', function(mod)
    pcall(require, mod)
  end)

  require('mason-null-ls').setup {
    ensure_installed = { 'stylua' },
    automatic_setup = true,
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
