local M = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'romgrk/nvim-treesitter-context',
    'andymass/vim-matchup',
    { 'nvim-treesitter/playground', lazy = true },
  },
}

function M.config()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'http', 'json' },
    highlight = { enable = true },
    endwise = { enable = true },
    matchup = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ak'] = '@block.outer',
          ['ik'] = '@block.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']f'] = '@function.outer',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
        },
      },
    },
  }
  require('treesitter-context').setup {
    patterns = {
      ['ruby.rspec'] = {
        'do_block',
      },
    },
  }
end

return M