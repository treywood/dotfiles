return {
  'nvim-lua/plenary.nvim',
  'haya14busa/is.vim',
  'ggandor/leap.nvim',
  'hrsh7th/cmp-nvim-lsp',
  'vim-test/vim-test',
  'mracos/mermaid.vim',
  { 'tpope/vim-fugitive', dependencies = 'tpope/vim-rhubarb' },
  { 'lewis6991/gitsigns.nvim', config = true },
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
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_theme = 'light'
    end,
  },
}
