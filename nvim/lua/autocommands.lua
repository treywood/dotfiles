local Job = require('plenary.job')

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
  end,
})

local function set_tab_title(tab_title)
  local kitty_listen_on = os.getenv('KITTY_LISTEN_ON')
  local args = { '@', '--to=' .. kitty_listen_on, 'set-tab-title' }

  if tab_title then
    table.insert(args, tab_title)
  end

  Job
    :new({
      cwd = vim.fn.getcwd(),
      command = 'kitty',
      args = args,
      on_stderr = function(_, err)
        print('kitty error: ' .. err)
      end,
    })
    :start()
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.argc() == 0 then
      local repo_name = vim.fn.system([[git remote get-url --all origin | sed -E 's/.+\/(.+)\.git$/\1/']])
      local tab_name = string.format('nvim (%s)', repo_name:gsub('%s*$', ''))
      set_tab_title(tab_name)
    end
  end,
})
vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    set_tab_title(nil)
  end,
})
