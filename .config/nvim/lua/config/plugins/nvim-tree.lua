return {
  'nvim-tree/nvim-tree.lua',
  keys = {
    { '-', '<cmd>NvimTreeToggle<cr>' },
    { '+', '<cmd>NvimTreeFindFileToggle<cr>' },
  },
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
}
