return {
  'tpope/vim-fugitive',
  {
    'tpope/vim-rhubarb',
    keys = {
      { '<leader>gy', '<cmd>GBrowse<cr>', mode = 'n' },
      { '<leader>gy', '<cmd>GBrowse!<cr>', mode = 'v' },
    },
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
}
