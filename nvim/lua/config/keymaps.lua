local util = require('util')
local opts = { silent = true }

vim.keymap.set('n', '<esc>', '<cmd>nohl<CR><esc>')
vim.keymap.set('n', '<leader>W', ':%bd!<CR>', opts)
vim.keymap.set('n', '<leader>w', ':%bd!|e#|bd!#<CR>', opts)
vim.keymap.set('n', 'K', util.open, opts)
vim.keymap.set('n', 'mm', 'gcc', { remap = true, silent = true })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

vim.keymap.set('i', '<C-n>', "<cmd>lua require('luasnip').change_choice(1)<cr>", opts)

vim.keymap.set({ 'v', 'n' }, 'm', 'gc', { remap = true, silent = true })
