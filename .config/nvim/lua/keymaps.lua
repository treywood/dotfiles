Keymaps = {}

function Keymaps.setup()
  local opts = { silent = true }
  vim.api.nvim_set_keymap('n', '<C-e>', ':Telescope oldfiles cwd_only=true<CR>', opts)
  vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope git_files<CR>', opts)
  vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope live_grep<CR>', opts)
  vim.api.nvim_set_keymap('n', '<C-b>', ':Telescope buffers<CR>', opts)
  vim.api.nvim_set_keymap('n', '<C-j>', ':Telescope lsp_document_symbols<CR>', opts)

  vim.api.nvim_set_keymap('', '/', '<Plug>(incsearch-forward)', opts)
  vim.api.nvim_set_keymap('', '?', '<Plug>(incsearch-backward)', opts)
  vim.api.nvim_set_keymap('', 'n', '<Plug>(incsearch-nohl-n)', opts)
  vim.api.nvim_set_keymap('', 'N', '<Plug>(incsearch-nohl-N)', opts)

  vim.api.nvim_set_keymap('n', '-', ':NvimTreeToggle<CR>', opts)
  vim.api.nvim_set_keymap('n', '=', ':NvimTreeFindFile<CR>', opts)

  vim.api.nvim_set_keymap('n', '<leader>tn', ':TestNearest<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>tf', ':TestFile<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>tt', ':TestLast<CR>', opts)

  vim.api.nvim_set_keymap('n', '<leader>W', ':%bd<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>w', ':%bd|e#|bd#<CR>', opts)

  vim.api.nvim_set_keymap('', '<leader>gy', ':GBrowse!<CR>', opts)

  vim.api.nvim_set_keymap('n', ']c', '<cmd>Gitsigns next_hunk<CR>', opts)
  vim.api.nvim_set_keymap('n', '[c', '<cmd>Gitsigns prev_hunk<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>hu', '<cmd>Gitsigns reset_hunk<CR>', opts)

  vim.api.nvim_set_keymap('n', '<leader>cn', ':cnext<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>cN', ':cprevious<CR>', opts)

  vim.api.nvim_set_keymap('n', '<M-K>', 'ddkP', opts)
  vim.api.nvim_set_keymap('n', '<M-J>', 'ddp', opts)

  vim.api.nvim_set_keymap('n', '<leader>gy', ':GBrowse<CR>', opts)

  vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)

  vim.api.nvim_set_keymap('i', '<C-j>', "<C-O>:lua require('luasnip').change_choice(1)<CR>", opts)

  vim.api.nvim_set_keymap('i', '<C-Space>i', '<Plug>(sq-connect-insert-id)', opts)
  vim.api.nvim_set_keymap('i', '<C-Space>l', '<Plug>(sq-connect-insert-location-id)', opts)
  vim.api.nvim_set_keymap('i', '<C-Space>m', '<Plug>(sq-connect-insert-merchant-id)', opts)
  vim.api.nvim_set_keymap('i', '<C-Space>c', '<Plug>(sq-connect-insert-customer-id)', opts)

  vim.api.nvim_set_keymap('v', '<C-Space>i', '<Plug>(sq-connect-insert-id)', opts)
  vim.api.nvim_set_keymap('v', '<C-Space>l', '<Plug>(sq-connect-insert-location-id)', opts)
  vim.api.nvim_set_keymap('v', '<C-Space>m', '<Plug>(sq-connect-insert-merchant-id)', opts)
  vim.api.nvim_set_keymap('v', '<C-Space>c', '<Plug>(sq-connect-insert-customer-id)', opts)

  vim.api.nvim_set_keymap('s', '<C-Space>i', '<Plug>(sq-connect-insert-id)', opts)
  vim.api.nvim_set_keymap('s', '<C-Space>l', '<Plug>(sq-connect-insert-location-id)', opts)
  vim.api.nvim_set_keymap('s', '<C-Space>m', '<Plug>(sq-connect-insert-merchant-id)', opts)
  vim.api.nvim_set_keymap('s', '<C-Space>c', '<Plug>(sq-connect-insert-customer-id)', opts)

  opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap('n', ';', 'm', opts)
  vim.api.nvim_set_keymap('n', "'", '`', opts)
end

function Keymaps.lsp_keymaps(bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

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
