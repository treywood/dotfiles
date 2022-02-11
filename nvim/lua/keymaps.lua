Keymaps = {}

function Keymaps.setup_keymaps()
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n','<C-e>',"<cmd>lua require'telescope.builtin'.oldfiles{cwd_only=true}<CR>", opts)
  vim.api.nvim_set_keymap('n','<C-p>',':Telescope git_files<CR>', opts)
  vim.api.nvim_set_keymap('n','<C-f>',':Telescope live_grep<CR>', opts)
  vim.api.nvim_set_keymap('n','<C-b>',':Telescope buffers<CR>', opts)
  vim.api.nvim_set_keymap('n','<C-j>',':Telescope lsp_document_symbols<CR>', opts)

  opts = { silent=true }
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

  vim.api.nvim_set_keymap('n','-',':NERDTreeToggle<CR>', opts)
  vim.api.nvim_set_keymap('n','=',':NERDTreeFind<CR>', opts)

  --vim.api.nvim_set_keymap('n','<leader>t',':call RunNearestSpec()<CR>', opts)
  --vim.api.nvim_set_keymap('n','<leader>r',':call RunLastSpec()<CR>', opts)
  vim.api.nvim_set_keymap('n','<leader>tn',':TestNearest<CR>', opts)
  vim.api.nvim_set_keymap('n','<leader>tf',':TestFile<CR>', opts)
  vim.api.nvim_set_keymap('n','<leader>tt',':TestLast<CR>', opts)

  vim.api.nvim_set_keymap('n','<leader>W',':%bd<CR>',opts)
  vim.api.nvim_set_keymap('n','<leader>w',':%bd|e#|bd#<CR>',opts)
end

function Keymaps.setup_lsp_keymaps(bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
  buf_set_keymap('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
  buf_set_keymap('n', 'gr', ':Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', '<leader>a', ':Telescope lsp_code_actions theme=cursor<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

return Keymaps
