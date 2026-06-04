vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  callback = function(args)
    local MiniStarter = require('mini.starter')
    local next_item = function()
      MiniStarter.update_current_item('next')
    end
    local prev_item = function()
      MiniStarter.update_current_item('prev')
    end

    local options = { buffer = args.buf }
    vim.keymap.set('n', '<C-j>', next_item, options)
    vim.keymap.set('n', '<C-k>', prev_item, options)
    -- Historical: mini.starter swallowed the global <C-p> binding at the
    -- time this was added. Possibly unneeded on current versions; left in
    -- as a buffer-local safety net.
    vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', options)
  end,
})
