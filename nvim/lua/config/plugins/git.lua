return {
  {
    'tpope/vim-rhubarb',
    dependencies = {
      'tpope/vim-fugitive',
      cmd = { 'G', 'Git', 'Gvdiffsplit' },
    },
    keys = {
      { '<leader>gy', ':GBrowse<cr>', silent = true },
      { '<leader>gy', ':GBrowse!<cr>', mode = 'v', silent = true },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      require('gitsigns').setup()
      vim.keymap.set('n', ']c', '<cmd>Gitsigns next_hunk<cr>')
      vim.keymap.set('n', '[c', '<cmd>Gitsigns prev_hunk<cr>')
      vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<cr>')
      vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns reset_hunk<cr>')
    end,
  },
}
