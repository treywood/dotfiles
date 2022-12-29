local M = {}

function M.get_capabilities()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

function M.on_attach(client, bufnr)
  require('illuminate').on_attach(client)
  require('lsp-status').on_attach(client)

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
  vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
  vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', opts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>rn', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true, buffer = bufnr })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<C-j>', ':Telescope lsp_document_symbols<CR>', opts)
end

function M.setup(server_name)
  require('lspconfig')[server_name].setup {
    on_attach = M.on_attach,
    capabilities = M.get_capabilities(),
    flags = {
      debounce_text_changes = 150,
    },
  }
end

function M.configure(server_name, config)
  require('lspconfig.configs')[server_name] = config
  M.setup(server_name)
end

return M
