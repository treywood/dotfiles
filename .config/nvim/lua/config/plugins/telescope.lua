local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require('telescope-live-grep-args.actions')

telescope.setup {
  defaults = {
    path_display = { 'smart' },
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

vim.keymap.set('n', '<C-e>', '<cmd>Telescope oldfiles cwd_only=true<cr>', { silent = true })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { silent = true })
vim.keymap.set('n', '<C-b>', '<cmd>Telescope buffers<cr>', { silent = true })
vim.keymap.set('n', '<C-y>', '<cmd>Telescope git_status<cr>', { silent = true })
vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep_args<cr>', { silent = true })
