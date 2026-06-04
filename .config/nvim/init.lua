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

-- Optional per-machine override. Silent only when the module is absent —
-- any other error (syntax, runtime) gets surfaced so a broken local.lua
-- doesn't disappear.
local ok, err = pcall(require, 'config.local')
if not ok and not err:match("^module 'config%.local' not found") then
  vim.notify('config.local failed to load: ' .. err, vim.log.levels.ERROR)
end
