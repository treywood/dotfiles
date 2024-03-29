return {
  'github/copilot.vim',
  cmd = 'Copilot',
  event = 'InsertEnter',
  init = function()
    vim.cmd([[
      let g:copilot_node_command = trim(system('brew --prefix')) . '/bin/node'
      let g:copilot_no_tab_map = v:true

      imap <expr><script><silent> <C-Space> copilot#Accept()
      imap <C-Enter> <Plug>(copilot-suggest)
      imap <C-j> <Plug>(copilot-next)
      imap <C-k> <Plug>(copilot-previous)
      imap <C-l> <Plug>(copilot-accept-word)

      augroup copilot
        autocmd!
        autocmd TextChangedI * call copilot#Suggest()
      augroup END
    ]])
  end,
}
