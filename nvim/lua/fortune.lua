M = {}

local function exec(cmd)
  local tmp = os.tmpname()
  local exit = os.execute(cmd .. ' > ' .. tmp)
  if exit > 0 then
    os.remove(tmp)
    return exit, nil
  end

  local f = io.open(tmp)
  local text = f:read('a')
  f:close()

  os.remove(tmp)
  return exit, text
end

function M.header(cols)
  cols = cols or 70

  local exit, text = exec('fortune')
  if exit > 0 then
    return nil
  end

  return text
end

return M
