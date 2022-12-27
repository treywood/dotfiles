local M = {}

function M.get_capabilities()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

function M.on_attach(client, bufnr)
  require('config.keymaps').setup_lsp(bufnr)
  require('illuminate').on_attach(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
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