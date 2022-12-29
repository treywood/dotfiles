return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      'rcarriga/nvim-notify',
      config = {
        render = 'minimal',
        stages = 'static',
        timeout = 2000,
        top_down = false,
      },
    },
  },
  config = {
    cmdline = {
      format = {
        cmdline = { icon = ':' },
        search_down = { icon = '' },
        search_up = { icon = '' },
        help = { icon = '' },
      },
    },
    lsp = {
      progress = {
        enabled = false,
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },
    views = {
      mini = {
        align = 'message-left',
      },
    },
  },
}
