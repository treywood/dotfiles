local lazy_config = {
  checker = {
    enabled = true,
  },
}

local ok, local_config = pcall(require, 'config.lazy.config')
if ok then
  lazy_config = vim.tbl_deep_extend('force', local_config)
end

require('lazy').setup('config.plugins', lazy_config)
