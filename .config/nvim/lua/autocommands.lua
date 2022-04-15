vim.api.nvim_create_autocmd('FileType', {
  pattern = 'NvimTree',
  callback = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      once = true,
      command = 'setlocal cursorline',
    })
  end,
})
