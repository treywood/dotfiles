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

local lsp_group = vim.api.nvim_create_augroup('language_servers', {})

function M.setup(config)
  local default_config = {
    on_attach = on_attach,
    capabilities = get_capabilities(),
    flags = {
      debounce_text_changes = 150,
    },
  }

  config = vim.tbl_deep_extend('force', default_config, config)
  vim.api.nvim_create_autocmd('FileType', {
    group = lsp_group,
    pattern = config.filetypes,
    callback = function()
      if config.formatter then
        local null_ls = require('null-ls')
        null_ls.register(null_ls.builtins.formatting[config.formatter])
      end
      vim.lsp.start(config)
    end,
  })
end

return M
