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
      event = '',
      ft = '',
      init = '⚙',
      keys = '',
      -- plugin = '',
      runtime = '',
      source = '',
      start = '',
      task = '',
    },
  },
}

local ok, local_config = pcall(require, 'config.lazy.config')
if ok then
  lazy_config = vim.tbl_deep_extend('force', local_config)
end

require('lazy').setup('config.plugins', lazy_config)
