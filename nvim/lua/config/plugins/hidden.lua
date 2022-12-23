function ls(path, fn)
  local handle = vim.loop.fs_scandir(path)
  while handle do
    local name = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end

    if fn(name) == false then
      break
    end
  end
end

local specs = {}
local root = vim.fn.stdpath('config') .. '/lua/config/plugins/hidden/'

ls(root, function(module)
  module = 'config.plugins.hidden.' .. module:sub(1, -5)
  local ok, spec = pcall(require, module)
  if ok then
    table.insert(specs, spec)
    return true
  else
    print('error loading ' .. module)
    return false
  end
end)

return specs
