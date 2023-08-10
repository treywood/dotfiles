local M = {}

local format_group = vim.api.nvim_create_augroup('formatters', {})

local function get_cmd_string(config)
  local cmd_str = 'silent %!'

  for i, arg in ipairs(config.cmd) do
    if i == 1 then
      cmd_str = cmd_str .. arg
    elseif arg == '$FILENAME' then
      arg = vim.fn.expand('%')
    end

    if i > 1 then
      cmd_str = cmd_str .. ' ' .. arg
    end
  end

  return cmd_str
end

function M.setup(config)
  local cmd_str = get_cmd_string(config)

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = vim.fn.bufnr('%'),
    group = format_group,
    callback = function()
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
