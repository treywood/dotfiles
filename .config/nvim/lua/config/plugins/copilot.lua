return {
  'github/copilot.vim',
  cmd = 'Copilot',
  event = 'InsertEnter',
  init = function()
    vim.cmd([[
      let g:copilot_node_command = trim(system('brew --prefix')) . '/bin/node'

      imap <C-Space> <Plug>(copilot-accept-line)
      imap <C-Enter> <Plug>(copilot-suggest)
      imap <C-j> <Plug>(copilot-next)
      imap <C-k> <Plug>(copilot-previous)

      augroup copilot
        autocmd!
        autocmd TextChangedI * :call copilot#Suggest()
      augroup END
    ]])
  end,
}
