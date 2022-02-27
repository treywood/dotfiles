M = {}

function M.header()
  local tmp = os.tmpname()
  local exit = os.execute('fortune > ' .. tmp)
  if exit > 0 then
    os.remove(tmp)
    return nil
  end

  local f = io.open(tmp)
  local text = f:read('a')
  f:close()

  os.remove(tmp)
  return text
end

return M
