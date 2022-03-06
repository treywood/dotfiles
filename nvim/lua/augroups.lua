local util = require('util')

util.augroups {
  nvimtree_cursorline = {
    'FileType NvimTree au BufEnter <buffer> setlocal cursorline',
  },
}
