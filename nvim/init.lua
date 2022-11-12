-- This init.lua file will clone hotpot into your plugins directory if
-- it is missing. Do not forget to also add hotpot to your plugin manager
-- or it may uninstall hotpot!

-- Consult your plugin-manager documentation for where it installs plugins.
-- packer.nvim
-- local hotpot_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/hotpot.nvim'
-- paq.nvim
local hotpot_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/hotpot.nvim'

if vim.fn.empty(vim.fn.glob(hotpot_path)) > 0 then
  print('Could not find hotpot.nvim, cloning new copy to', hotpot_path)
  vim.fn.system { 'git', 'clone', 'https://github.com/rktjmp/hotpot.nvim', hotpot_path }
  vim.cmd('helptags ' .. hotpot_path .. '/doc')
end

-- Enable fnl/ support
require('hotpot')

-- Now you can load fennel code, so you could put the rest of your
-- config in a separate `~/.config/nvim/fnl/my_config.fnl` or
-- `~/.config/nvim/fnl/plugins.fnl`, etc.

require('plugins')
require('options')
require('theme')
require('keymaps').setup()
require('lsp')
require('autocommands')

vim.api.nvim_create_user_command('PC', 'PackerCompile', {})
vim.api.nvim_create_user_command('PS', 'PackerSync', {})

vim.api.nvim_create_user_command('Notes', function(opts)
  local name = opts.fargs[1] or 'notes'
  vim.cmd(string.format('tabe ~/notes/%s', name))
end, {
  nargs = '?',
  force = true,
  complete = function()
    return vim.fn.readdir(string.format('%s/notes/', os.getenv('HOME')))
  end,
})

vim.api.nvim_create_user_command('Kochiku', function(opts)
  local command = '!sq kochiku'
  if #opts.fargs > 0 then
    command = string.format('%s %s', command, table.concat(opts.fargs, ' '))
  end
  vim.cmd(command)
end, {
  nargs = '?',
  force = true,
  complete = function()
    return { '--canary' }
  end,
})
vim.api.nvim_create_user_command('Migrate', function()
  vim.cmd('!rails db:migrate && rails db:migrate RAILS_ENV=test')
end, {})
