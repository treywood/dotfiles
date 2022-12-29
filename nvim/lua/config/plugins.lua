return {
  'nvim-lua/plenary.nvim',
  'hrsh7th/cmp-nvim-lsp',
  { 'nvim-tree/nvim-web-devicons', lazy = true },
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
  {
    'vim-test/vim-test',
    keys = {
      { '<leader>tn', '<cmd>TestNearest<cr>' },
      { '<leader>tf', '<cmd>TestFile<cr>' },
      { '<leader>tt', '<cmd>TestLast<cr>' },
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
