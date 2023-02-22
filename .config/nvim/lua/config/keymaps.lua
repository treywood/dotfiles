local opts = { silent = true }

vim.keymap.set('n', '<esc>', '<cmd>nohl<CR><esc>')
vim.keymap.set('n', '<leader>W', ':%bd!<CR>', opts)
vim.keymap.set('n', '<leader>w', ':%bd!|e#|bd!#<CR>', opts)

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

vim.keymap.set('i', '<C-j>', "<cmd>lua require('luasnip').change_choice(1)<cr>", opts)
