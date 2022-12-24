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

return M
