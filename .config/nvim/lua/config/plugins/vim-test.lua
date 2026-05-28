vim.g['test#custom_runners'] = { java = { 'Bazeltest' } }

vim.keymap.set('n', '<leader>tn', '<cmd>TestNearest<cr>', { silent = true })
vim.keymap.set('n', '<leader>tf', '<cmd>TestFile<cr>', { silent = true })
vim.keymap.set('n', '<leader>tt', '<cmd>TestLast<cr>', { silent = true })
