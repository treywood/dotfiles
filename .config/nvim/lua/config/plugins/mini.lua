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
    'echasnovski/mini.pairs',
    name = 'mini.pairs',
    branch = 'stable',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mini.pairs').setup()
    end,
  },
  {
    'echasnovski/mini.surround',
    name = 'mini.surround',
    branch = 'stable',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mini.surround').setup()
    end,
  },
  {
    'echasnovski/mini.comment',
    name = 'mini.comment',
    branch = 'stable',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mini.comment').setup {
        mappings = {
          comment = 'm',
          comment_line = 'mm',
          textobject = 'm',
        },
      }
    end,
  },
}
