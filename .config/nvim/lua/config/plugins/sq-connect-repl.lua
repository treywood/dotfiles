vim.api.nvim_create_autocmd('FileType', {
  pattern = 'http',
  callback = function(args)
    vim.keymap.set({ 'i', 'v' }, '<c-i>l', '<Plug>(sq-connect-insert-location-id)', { buffer = args.buf })
    vim.keymap.set({ 'i', 'v' }, '<c-i>m', '<Plug>(sq-connect-insert-merchant-id)', { buffer = args.buf })
    vim.keymap.set({ 'i', 'v' }, '<c-i>c', '<Plug>(sq-connect-insert-customer-id)', { buffer = args.buf })
  end,
})

require('kulala').setup {
  debug = true,
  winbar = true,
  default_winbar_panes = { 'body', 'headers', 'script_output' },
}

require('sq-connect-repl').setup {
  config_file = os.getenv('HOME') .. '/sq-connect-repl.json',
}
