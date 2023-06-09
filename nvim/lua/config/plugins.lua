return {
  { import = 'config.plugins.hidden' },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'haya14busa/is.vim',
    keys = {
      { 'n', '<Plug>(is-n)zzzv', silent = true },
      { 'N', '<Plug>(is-N)zzzv', silent = true },
      { '*', '<Plug>(is-*)', silent = true },
      { '#', '<Plug>(is-#)', silent = true },
    },
  },
  -- {
  --   'vim-test/vim-test',
  --   keys = {
  --     { '<leader>tn', '<cmd>TestNearest<cr>', silent = true },
  --     { '<leader>tf', '<cmd>TestFile<cr>', silent = true },
  --     { '<leader>tt', '<cmd>TestLast<cr>', silent = true },
  --   },
  -- },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'olimorris/neotest-rspec',
      'mfussenegger/nvim-dap',
      'antoinemadec/FixCursorHold.nvim',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require('neotest-rspec'),
        },
      }
    end,
    keys = {
      {
        '<leader>tn',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        silent = true,
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run { vim.fn.expand('%'), strategy = 'dap' }
        end,
        silent = true,
      },
      {
        '<leader>tt',
        function()
          require('neotest').run.run_last { strategy = 'dap' }
        end,
        silent = true,
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
}
