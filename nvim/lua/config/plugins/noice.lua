return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = {
    cmdline = {
      format = {
        cmdline = { icon = ':' },
        help = { icon = '?' },
        search_down = { icon = '' },
        search_up = { icon = '' },
      },
    },
    lsp = {
      progress = {
        enabled = true,
        view = 'mini',
      },
      message = {
        enabled = true,
        view = 'virtualtext',
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    messages = {
      enabled = false,
    },
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
    views = {
      mini = {
        timeout = 1000,
        position = { row = -2 },
        win_options = { winblend = 100 },
      },
    },
  },
}
