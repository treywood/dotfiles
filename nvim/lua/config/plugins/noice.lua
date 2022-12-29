return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = {
    cmdline = {
      format = {
        cmdline = { icon = '', title = '' },
        help = { icon = '?', title = '' },
        search_down = { icon = ' ↘', title = '' },
        search_up = { icon = ' ↖', title = '' },
      },
    },
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    messages = {
      view = 'mini',
      view_error = 'mini',
      view_warn = 'mini',
      view_search = 'virtualtext',
    },
    presets = {
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
    views = {
      mini = {
        timeout = 3000,
        position = { row = -2, col = -2 },
        win_options = { winblend = 100 },
      },
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          any = {
            { cmdline = 'Inspect' },
            { cmdline = 'Git' },
          },
        },
        view = 'popup',
      },
      {
        filter = {
          event = 'msg_show',
          find = 'COMMIT_EDITMSG',
        },
        opts = { skip = true },
      },
    },
    commands = {
      rubocop = {
        view = 'popup',
        opts = { enter = true, format = 'details' },
        filter = { find = 'rubocop' },
        filter_opts = { count = 1 },
      },
    },
  },
}
