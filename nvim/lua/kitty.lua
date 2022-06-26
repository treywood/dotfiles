local Job = require('plenary.job')
local Kitty = {}

local kitty_listen_on = os.getenv('KITTY_LISTEN_ON')

function Kitty.run(args, opts)
  print(string.format('kitty %s', table.concat(args, ' ')))
  local default_opts = {
    cwd = vim.fn.getcwd(),
    command = 'kitty',
    args = args,
    on_stderr = function(_, err)
      print(string.format('kitty error: %s', err))
    end,
  }
  opts = vim.tbl_deep_extend('keep', default_opts, opts or {})
  return Job:new(opts):start()
end

function Kitty.remote(args, opts)
  local remote_args = { '@', '--to=' .. kitty_listen_on }
  for _, v in ipairs(args) do
    table.insert(remote_args, v)
  end
  return Kitty.run(remote_args, opts)
end

function Kitty.is_kitty()
  return kitty_listen_on ~= nil
end

return Kitty
