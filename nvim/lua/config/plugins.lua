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
  {
    'ggandor/leap.nvim',
    keys = {
      { '<leader>s', '<Plug>(leap-forward-to)', silent = true },
      { '<leader>S', '<Plug>(leap-backward-to)', silent = true },
    },
  },
  {
    'vim-test/vim-test',
    keys = {
      { '<leader>tn', '<cmd>TestNearest<cr>', silent = true },
      { '<leader>tf', '<cmd>TestFile<cr>', silent = true },
      { '<leader>tt', '<cmd>TestLast<cr>', silent = true },
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
    'm4xshen/smartcolumn.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      colorcolumn = 120,
      disabled_filetypes = {
        'fugitive',
        'gitcommit',
        'help',
        'lazy',
        'markdown',
        'starter',
        'text',
      },
    },
  },
}
