return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufNewFile', 'BufReadPre' },
    import = 'config.lsp',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp', lazy = true },
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
    },
    init = function()
      vim.g.Illuminate_delay = 500
      vim.diagnostic.config {
        virtual_text = false,
      }
    end,
  },
  { 'RRethy/vim-illuminate', lazy = true },
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },
}
