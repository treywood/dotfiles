local M = {}

function M.ls(path, fn)
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

local lua_root = vim.fn.stdpath('config') .. '/lua/'
function M.lsmod(modpath, fn)
  local path = lua_root .. modpath:gsub('%.', '/')
  return M.ls(path, function(name)
    if name:sub(-4) == '.lua' then
      fn(modpath .. '.' .. name:sub(1, -5))
    end
  end)
end

function M.devpath(path)
  path = path and ('/' .. path) or ''
  return os.getenv('SQUARE_HOME') .. path
end

return M
