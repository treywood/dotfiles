local util = require('util')

local M = {}

local function get_capabilities()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), capabilities)
end

local function on_attach(client, bufnr)
  require('illuminate').on_attach(client)

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', function()
    if not util.open() then
      vim.lsp.buf.hover()
    end
  end, opts)
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

function M.setup(config)
  local default_config = {
    on_attach = on_attach,
    capabilities = get_capabilities(),
    root_dir = util.root_pattern { '.git' },
    flags = {
      debounce_text_changes = 150,
    },
  }

  config = vim.tbl_deep_extend('force', default_config, config)
  vim.lsp.start(config)
end

return M
