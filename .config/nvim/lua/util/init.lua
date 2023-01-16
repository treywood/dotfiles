local M = {}

function M.devpath(path)
  path = path and ('/' .. path) or ''
  return os.getenv('DEV_HOME') .. path
end

return M
