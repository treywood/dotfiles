M = {}

function M.header()
  local tmp = os.tmpname()
  local exit = os.execute('fortune > ' .. tmp)
  local text = nil

  if exit == 0 then
    local f = io.open(tmp)
    text = f:read('a')
    f:close()
  end

  os.remove(tmp)
  return text
end

return M
