vim.api.nvim_create_user_command('LspRestart', function()
  for _, client in ipairs(vim.lsp.get_clients()) do
    local config = client.config
    local function restart()
      if client:is_stopped() then
        vim.lsp.start(config)
      else
        vim.defer_fn(restart, 500)
      end
    end

    client:stop()
    vim.defer_fn(restart, 500)
  end
end, {})
