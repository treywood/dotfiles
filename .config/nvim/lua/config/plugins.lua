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
    'vim-test/vim-test',
    keys = {
      { '<leader>tn', '<cmd>TestNearest<cr>', silent = true },
      { '<leader>tf', '<cmd>TestFile<cr>', silent = true },
      { '<leader>tt', '<cmd>TestLast<cr>', silent = true },
    },
    init = function()
      vim.cmd([[
        let test#custom_runners = {'java':['Bazeltest']}
      ]])
    end,
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
    'RRethy/vim-illuminate',
    lazy = true,
    init = function()
      vim.g.Illuminate_delay = 500
      vim.diagnostic.config {
        virtual_text = false,
      }
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      progress = {
        display = {
          progress_icon = { pattern = 'dots_snake', period = 1 },
        },
      },
    },
  },
}
