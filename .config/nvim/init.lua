-- disable built-in plugins we don't use
for _, plugin in ipairs({ 'gzip', 'netrwPlugin', 'matchit', 'matchparen', 'tarPlugin', 'tohtml', 'zipPlugin', 'tutor' }) do
  vim.g['loaded_' .. plugin] = 1
end

vim.cmd('packloadall')

require('config.options')
require('config.plugins')
require('config.keymaps')
require('config.autocommands')
require('config.lsp')

pcall(require, 'config.local')

vim.api.nvim_create_user_command('Kulala', function()
  require('kulala').scratchpad()
end, {})

vim.filetype.add {
  extension = {
    mmd = 'mermaid',
    sq = 'sql',
    sqm = 'sql',
  },
}
