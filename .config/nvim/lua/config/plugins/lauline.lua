return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  config = {
    options = {
      theme = 'everforest',
      disabled_filetypes = {
        statusline = { 'NvimTree' },
      },
    },
    sections = {
      lualine_b = { { 'branch', icon = '' } },
      lualine_c = { { 'filename', file_status = true, path = 1 } },
      lualine_x = {
        { require('lazy.status').updates, cond = require('lazy.status').has_updates },
      },
      lualine_y = { 'filetype' },
    },
    tabline = {
      lualine_a = { { 'tabs', mode = 1 } },
      lualine_z = {},
    },
    extensions = {
      {
        filetypes = { 'fugitive' },
        sections = {
          lualine_a = { { 'branch', icon = '' } },
        },
      },
    },
  },
}
