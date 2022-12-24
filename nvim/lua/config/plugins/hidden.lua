local specs = {}
local root = vim.fn.stdpath('config') .. '/lua/config/plugins/hidden/'

if vim.loop.fs_stat(root) then
  local util = require('util')
  util.lsmod('config.plugins.hidden', function(module)
    local ok, spec = pcall(require, module)
    if ok then
      table.insert(specs, spec)
      return true
    else
      print('error loading ' .. module)
      return false
    end
  end)
end

return specs
