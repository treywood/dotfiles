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
