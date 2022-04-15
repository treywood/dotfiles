vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = function(args)
    vim.api.nvim_create_autocmd('BufEnter', {
      command = 'setlocal cursorline',
      buffer = args.buf,
    })
  end,
})
