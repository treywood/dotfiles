local Kitty = require('kitty')

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
    vim.keymap.set('n', '<C-p>', ':Telescope git_files<CR>', options)
    vim.keymap.set('n', '-', ':NvimTreeToggle<CR>', options)
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  pattern = '**/spec/**/*_spec.rb',
  callback = function()
    vim.schedule(function()
      vim.cmd('setfiletype ruby.rspec')
    end)
  end,
})

if Kitty.is_kitty() then
  local kitty_window_id = os.getenv('KITTY_WINDOW_ID')

  local function set_tab_title(tab_title)
    Kitty.remote { 'set-tab-title', '--match', 'window_id:' .. kitty_window_id, tab_title }
  end

  if vim.fn.argc() == 0 then
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local tab_name
        local repo_name = vim.fn.system([[git remote get-url --all origin | sed -E 's/.+\/(.+)\.git$/\1/']])
        if vim.v.shell_error ~= nil then
          local dir_name = string.gsub(vim.fn.getcwd(), '.+/', '')
          tab_name = string.format('nvim (%s)', dir_name)
        elseif repo_name ~= nil then
          tab_name = string.format('nvim (%s)', repo_name:gsub('%s*$', ''))
        end
        set_tab_title(tab_name)
      end,
    })
  end
  vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      set_tab_title(nil)
    end,
  })
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'kitty.conf',
    callback = function()
      Kitty.reload_config()
    end,
  })
end
