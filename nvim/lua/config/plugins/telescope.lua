local M = {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  cmd = 'Telescope',
  keys = {
    { '<C-e>', '<cmd>Telescope oldfiles cwd_only=true<cr>' },
    { '<C-p>', '<cmd>Telescope git_files<cr>' },
    { '<C-b>', '<cmd>Telescope buffers<cr>' },
    { '<C-y>', '<cmd>Telescope git_status<cr>' },
    { '<C-f>', '<cmd>Telescope live_grep_args<cr>' },
  },
}

function M.config()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local lga_actions = require('telescope-live-grep-args.actions')

  telescope.setup {
    defaults = {
      layout_strategy = 'bottom_pane',
      layout_config = {
        height = 0.4,
        prompt_position = 'bottom',
      },
      selection_caret = '  ',
      mappings = {
        i = {
          ['<C-n>'] = false,
          ['<C-p>'] = false,
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
          ['<C-c>'] = false,
          ['<Esc>'] = actions.close,
        },
      },
    },
    pickers = {
      buffers = {
        mappings = {
          i = {
            ['<C-w>'] = actions.delete_buffer,
          },
        },
      },
    },
    extensions = {
      'fzf',
      live_grep_args = {
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-l>'] = lga_actions.quote_prompt(),
          },
        },
      },
    },
  }

  telescope.load_extension('fzf')
  telescope.load_extension('live_grep_args')
end

return M
