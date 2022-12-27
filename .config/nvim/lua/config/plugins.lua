return {
  'nvim-lua/plenary.nvim',
  {
    'haya14busa/is.vim',
    keys = {
      { 'n', '<Plug>(is-n)zzzv' },
      { 'N', '<Plug>(is-N)zzzv' },
      { '*', '<Plug>(is-*)' },
      { '#', '<Plug>(is-#)' },
    },
  },
  {
    'ggandor/leap.nvim',
    keys = {
      { '<leader>s', '<Plug>(leap-forward-to)' },
      { '<leader>S', '<Plug>(leap-backward-to)' },
    },
  },
  'hrsh7th/cmp-nvim-lsp',
  {
    'vim-test/vim-test',
    keys = {
      { '<leader>tn', '<cmd>TestNearest<cr>' },
      { '<leader>tf', '<cmd>TestFile<cr>' },
      { '<leader>tt', '<cmd>TestLast<cr>' },
    },
  },
  'mracos/mermaid.vim',
  {
    'tpope/vim-fugitive',
    dependencies = 'tpope/vim-rhubarb',
    config = function()
      vim.keymap.set('n', '<leader>gy', '<cmd>GBrowse<cr>')
      vim.keymap.set('', '<leader>gy', '<cmd>GBrowse!<cr>')
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
      vim.keymap.set('n', ']c', '<cmd>Gitsigns next_hunk<cr>')
      vim.keymap.set('n', '[c', '<cmd>Gitsigns prev_hunk<cr>')
      vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<cr>')
      vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns reset_hunk<cr>')
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { '-', '<cmd>NvimTreeToggle<cr>' },
      { '+', '<cmd>NvimTreeFindFileToggle<cr>' },
    },
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
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_theme = 'light'
    end,
  },
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
  },
}
