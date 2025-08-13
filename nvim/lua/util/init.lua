local M = {}

function M.devpath(path)
  path = path and ('/' .. path) or ''
  return os.getenv('DEV_HOME') .. path
end

function M.is_list(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end

  return true
end

function M.open()
  local word = vim.fn.expand('<cWORD>')
  if word:match('^https?://') then
    vim.system { 'open', word }
    return true
  end
  return false
end

return M
