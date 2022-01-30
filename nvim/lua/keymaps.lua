local opts = { silent = true, noremap = true }
vim.api.nvim_set_keymap('n','<C-e>',':History<CR>', opts)
vim.api.nvim_set_keymap('n','<C-p>',':GFiles<CR>', opts)
vim.api.nvim_set_keymap('n','<C-f>',':Rg<CR>', opts)
vim.api.nvim_set_keymap('n','<C-j>',':SymbolsOutline<CR>', opts)
vim.api.nvim_set_keymap('n','<C-b>',':Buffers<CR>', opts)

local opts = { silent = true }
vim.cmd "let g:incsearch#auto_nohlsearch=1"
vim.api.nvim_set_keymap('','/','<Plug>(incsearch-forward)', opts)
vim.api.nvim_set_keymap('','?','<Plug>(incsearch-backward)', opts)
vim.api.nvim_set_keymap('','g/','<Plug>(incsearch-stay)', opts)
vim.api.nvim_set_keymap('','n','<Plug>(incsearch-nohl-n)', opts)
vim.api.nvim_set_keymap('','N','<Plug>(incsearch-nohl-N)', opts)
vim.api.nvim_set_keymap('','*','<Plug>(incsearch-nohl-*)', opts)
vim.api.nvim_set_keymap('','#','<Plug>(incsearch-nohl-#)', opts)
vim.api.nvim_set_keymap('','g*','<Plug>(incsearch-nohl-g*)', opts)
vim.api.nvim_set_keymap('','g#','<Plug>(incsearch-nohl-g#)', opts)

vim.api.nvim_set_keymap('n','=',':NERDTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n','-',':NERDTreeFind<CR>', opts)

vim.api.nvim_set_keymap('n','<leader>t',':call RunNearestSpec()<CR>', opts)
vim.api.nvim_set_keymap('n','<leader>r',':call RunLastSpec()<CR>', opts)
