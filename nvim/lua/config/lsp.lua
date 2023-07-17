vim.api.nvim_create_user_command('LspRestart', function()
  local lsp_clients = vim.lsp.buf_get_clients()
  for _, client in pairs(lsp_clients) do
    local config = client.config
    local function restart()
      if client.is_stopped() then
        vim.lsp.start(config)
      else
        vim.defer_fn(restart, 500)
      end
    end

    client.stop()
    vim.defer_fn(restart, 500)
  end
end, {})
