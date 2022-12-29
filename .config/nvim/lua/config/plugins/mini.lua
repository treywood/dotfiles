return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.comment').setup {
      mappings = {
        comment = 'm',
        comment_line = 'mm',
        textobject = 'm',
      },
    }

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

    require('mini.pairs').setup()
    require('mini.surround').setup()
  end,
}
