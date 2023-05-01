local util = require('util')
local Kitty = require('util.kitty')

-- language servers
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local handle = vim.loop.fs_scandir(vim.fn.stdpath('config') .. '/lua/config/lsp')
    while handle do
      local name, type = vim.loop.fs_scandir_next(handle)

      if not name then
        break
      end

      if type == 'file' then
        local mod = 'config.lsp.' .. name:gsub('.lua', '')
        local ok, configs = pcall(require, mod)

        if ok then
          if not util.is_list(configs) then
            configs = { configs }
          end
          for _, config in pairs(configs) do
            require('util.lsp').setup(config)
          end
        else
          print('failed loading lsp config: ' .. mod)
        end
      end
    end
  end,
})

-- other
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

if Kitty.is_kitty() then
  local kitty_window_id = os.getenv('KITTY_WINDOW_ID')

  local function set_tab_title(tab_title)
    Kitty.remote { 'set-tab-title', '--match', 'window_id:' .. kitty_window_id, tab_title }
  end

  if vim.fn.argc() == 0 then
    local async = require('plenary.async')
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = async.void(function()
        local tab_name
        local repo_name = vim.fn.system([[git remote get-url --all origin | sed -E 's/.+\/(.+)\.git$/\1/']])
        if vim.v.shell_error ~= nil then
          local dir_name = string.gsub(vim.fn.getcwd(), '.+/', '')
          tab_name = string.format('nvim (%s)', dir_name)
        elseif repo_name ~= nil then
          tab_name = string.format('nvim (%s)', repo_name:gsub('%s*$', ''))
        end
        set_tab_title(tab_name)
      end),
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
