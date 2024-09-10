local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim
    .system({
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    })
    :wait()
end
vim.opt.runtimepath:prepend(lazypath)

require('config.options')
require('config.lazy')
require('config.keymaps')
require('config.autocommands')
require('config.lsp')

pcall(require, 'config.local')

vim.api.nvim_create_user_command('Kulala', require('kulala').scratchpad, {})
