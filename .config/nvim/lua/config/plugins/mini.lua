local starter = require('mini.starter')
starter.setup {
  header = vim.system({ 'fortune' }, { text = true }):wait().stdout,
  items = {
    starter.sections.recent_files(10, true),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet('· '),
    starter.gen_hook.padding(15),
    starter.gen_hook.aligning('left', 'center'),
  },
}

require('mini.bracketed').setup { comment = { suffix = 'm' } }
require('mini.pairs').setup()
require('mini.surround').setup()
