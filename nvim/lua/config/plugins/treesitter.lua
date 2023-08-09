return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufNewFile', 'BufReadPre' },
    cmd = { 'TSUpdate', 'TSInstall' },
    build = ':TSUpdate',
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'romgrk/nvim-treesitter-context',
      'andymass/vim-matchup',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'vim', 'lua', 'query', 'python', 'bash', 'http', 'json' },
        highlight = { enable = true },
        endwise = { enable = true },
        matchup = { enable = true },
        indent = { enable = false },
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
              [']r'] = '@request',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[r'] = '@request',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
            },
          },
        },
      }
      require('treesitter-context').setup {
        patterns = {
          ruby = {
            'do_block',
          },
        },
      }
    end,
  },
}
