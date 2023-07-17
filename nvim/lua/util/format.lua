local M = {}

local format_group = vim.api.nvim_create_augroup('formatters', {})

function M.setup(config)
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = vim.fn.bufnr('%'),
    group = format_group,
    callback = function()
      local cmd_str = 'silent %!' .. config.cmd

      if config.args then
        for _, arg in ipairs(config.args) do
          if arg == '$FILENAME' then
            arg = vim.fn.expand('%')
          end
          cmd_str = cmd_str .. ' ' .. arg
        end
      end

      local saved_view = vim.fn.winsaveview()
      vim.cmd(cmd_str)
      if vim.v.shell_error ~= 0 then
        local error_str = vim.fn.join(vim.fn.getline(1, '$'), '\n')
        print('format error: ' .. error_str)
        vim.cmd('silent undo')
      end
      vim.fn.winrestview(saved_view)
    end,
  })
end

return M
