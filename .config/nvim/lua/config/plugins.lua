return {
  'nvim-lua/plenary.nvim',
  'haya14busa/is.vim',
  'ggandor/leap.nvim',
  'hrsh7th/cmp-nvim-lsp',
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'nvim-tree/nvim-tree.lua',
    config = {
      actions = {
        change_dir = {
          enable = false,
        },
      },
      filters = {
        dotfiles = true,
      },
      renderer = {
        icons = {
          show = {
            folder_arrow = false,
          },
        },
      },
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = '-', action = 'close' },
          },
        },
      },
    },
  },
  'mracos/mermaid.vim',
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_theme = 'light'
    end,
  },
  'vim-test/vim-test',
  { 'tpope/vim-fugitive', dependencies = 'tpope/vim-rhubarb' },
  { 'lewis6991/gitsigns.nvim', config = true },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.comment').setup {
        mappings = {
          comment = 'm',
          comment_line = 'mm',
          textobject = 'm',
        },
      }

      local starter = require('mini.starter')
      starter.setup {
        header = vim.fn.system('fortune'),
        items = {
          starter.sections.recent_files(10, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet('· '),
          starter.gen_hook.padding(15),
          starter.gen_hook.aligning('left', 'center'),
        },
      }

      require('mini.pairs').setup()
      require('mini.surround').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
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
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
          },
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
  },
}
