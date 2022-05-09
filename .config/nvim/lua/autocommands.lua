vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = function(args)
    vim.api.nvim_create_autocmd('BufEnter', {
      command = 'setlocal cursorline',
      buffer = args.buf,
    })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  callback = function(args)
    local MiniStarter = require('mini.starter')
    local options = { buffer = args.buf }
    local next_item = function()
      MiniStarter.update_current_item('next')
    end
    local prev_item = function()
      MiniStarter.update_current_item('prev')
    end

    vim.keymap.set('n', '<C-j>', next_item, options)
    vim.keymap.set('n', '<C-k>', prev_item, options)
    vim.keymap.set('n', '<C-p>', ':Telescope git_files<CR>', options)
  end,
})
