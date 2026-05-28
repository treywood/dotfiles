require('gitsigns').setup()

vim.keymap.set('n', ']c', '<cmd>Gitsigns next_hunk<cr>')
vim.keymap.set('n', '[c', '<cmd>Gitsigns prev_hunk<cr>')
vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<cr>')
vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns reset_hunk<cr>')

vim.keymap.set('n', '<leader>gy', ':GBrowse<cr>', { silent = true })
vim.keymap.set('v', '<leader>gy', ':GBrowse!<cr>', { silent = true })
