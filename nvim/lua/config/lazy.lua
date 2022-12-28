local lazy_config = {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  install = {
    colorscheme = { 'everforest', 'habamax' },
  },
  ui = {
    icons = {
      cmd = '⌘',
      config = '',
      event = '',
      ft = '',
      init = '⚙',
      keys = '',
      runtime = '',
      source = '',
      start = '',
      task = '',
    },
  },
  rtp = {
    disabled_plugins = {
      'gzip',
      'netrwPlugin',
      'matchit',
      'matchparen',
      'tarPlugin',
      'tohtml',
      'zipPlugin',
    },
  },
}

local ok, local_config = pcall(require, 'config.lazy.local')
if ok then
  lazy_config = vim.tbl_deep_extend('force', lazy_config, local_config)
end

require('lazy').setup('config.plugins', lazy_config)
