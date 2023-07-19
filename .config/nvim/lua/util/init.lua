local M = {}

function M.devpath(path)
  path = path and ('/' .. path) or ''
  return os.getenv('DEV_HOME') .. path
end

function M.root_pattern(files)
  table.insert(files, '.git')
  return vim.fs.dirname(vim.fs.find(files, { upward = true, path = vim.fn.expand('%:p:h') })[1])
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

return M
