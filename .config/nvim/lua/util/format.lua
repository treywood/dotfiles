local M = {}

local format_group = vim.api.nvim_create_augroup('formatters', {})

local function replace_cmd_params(cmd)
  local new_cmd = {}
  for _, part in ipairs(cmd) do
    if part == '$FILENAME' then
      table.insert(new_cmd, vim.fn.expand('%'))
    else
      table.insert(new_cmd, part)
    end
  end
  return new_cmd
end

function M.setup(config)
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = vim.fn.bufnr('%'),
    group = format_group,
    callback = function()
      if config.test and not config.test() then
        return
      end

      local obj = vim
        .system(replace_cmd_params(config.cmd), {
          stdin = vim.api.nvim_buf_get_lines(0, 0, -1, false),
          text = true,
        })
        :wait()

      if obj.code ~= 0 then
        print('format error: ' .. obj.stderr)
      else
        local saved_view = vim.fn.winsaveview()
        vim.b.formatoutput = obj.stdout
        vim.cmd([[
            silent :%delete _
            call setline(1, split(b:formatoutput, '\n'))
          ]])
        vim.b.formatoutput = nil
        vim.fn.winrestview(saved_view)
      end
    end,
  })
end

return M
