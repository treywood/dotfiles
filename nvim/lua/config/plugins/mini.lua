return {
  {
    'echasnovski/mini.starter',
    config = function()
      local starter = require('mini.starter')
      starter.setup {
        header = vim.fn.system('fortune'),
        items = {
          starter.sections.recent_files(10, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet('· '),
          starter.gen_hook.padding(15),
          starter.gen_hook.aligning('left', 'center'),
        },
      }
    end,
  },
  {
    'echasnovski/mini.bracketed',
    event = { 'BufNewFile', 'BufReadPre' },
    opts = {
      comment = { suffix = 'm' },
    },
    config = function(_, opts)
      require('mini.bracketed').setup(opts)
    end,
  },
  {
    'echasnovski/mini.pairs',
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      require('mini.pairs').setup()
    end,
  },
  {
    'echasnovski/mini.surround',
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      require('mini.surround').setup()
    end,
  },
}
