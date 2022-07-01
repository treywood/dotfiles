require('plugins')
require('options')
require('theme')
require('keymaps').setup()
require('lsp')
require('autocommands')

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
