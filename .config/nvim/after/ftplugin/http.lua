local opts = { silent = true }

vim.keymap.set('n', 'R', require('kulala').run, opts)
vim.api.nvim_buf_create_user_command(0, 'RunAll', function()
  require('kulala').run_all()
end, {})
