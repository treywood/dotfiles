local Job = require('plenary.job')
local Kitty = {}

local kitty_listen_on = os.getenv('KITTY_LISTEN_ON')
local kitty_pid = os.getenv('KITTY_PID')

function Kitty.run(args, opts)
  local default_opts = {
    cwd = vim.fn.getcwd(),
    command = 'kitty',
    args = args,
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        print(string.format('kitty error: %s; cmd: kitty %s', j:stderr_result(), table.concat(args, ' ')))
      end
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
  return kitty_pid ~= nil
end

function Kitty.reload_config()
  Job:new({
    cwd = vim.fn.getcwd(),
    command = 'kill',
    args = { '-s', 'SIGUSR1', kitty_pid },
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        print(string.format('error reloading kitty config: %s', j:stderr_result()))
      end
    end,
  }):start()
end

return Kitty
