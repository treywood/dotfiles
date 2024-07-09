local util = require('util')

local lazy_config = {
  checker = {
    enabled = true,
    notify = false,
    frequency = 3600 * 4, -- every 4 hours
  },
  change_detection = {
    notify = false,
  },
  install = {
    colorscheme = { 'everforest', 'habamax' },
  },
  dev = {
    path = util.devpath(),
  },
  ui = {
    icons = {
      cmd = '⌘',
      config = '',
      event = '󰅒',
      ft = '',
      init = '⚙',
      keys = '󰌆',
      runtime = '',
      source = '',
      start = '',
      task = '',
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'matchit',
        'matchparen',
        'tarPlugin',
        'tohtml',
        'zipPlugin',
        'tutor',
      },
    },
  },
}

local ok, local_config = pcall(require, 'config.lazy.local')
if ok then
  lazy_config = vim.tbl_deep_extend('force', lazy_config, local_config)
end

require('lazy').setup('config.plugins', lazy_config)
