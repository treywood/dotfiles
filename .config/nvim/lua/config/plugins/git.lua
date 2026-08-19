-- Hunk signs and diff navigation live in config.plugins.mini-diff.

vim.keymap.set('n', '<leader>gy', ':GBrowse<cr>', { silent = true })
vim.keymap.set('v', '<leader>gy', ':GBrowse!<cr>', { silent = true })
