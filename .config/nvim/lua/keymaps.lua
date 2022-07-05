local diff_files = require('pickers.diff_files')

Keymaps = {}

function Keymaps.setup()
  local opts = { silent = true }
  vim.keymap.set('n', '<C-e>', ':Telescope oldfiles cwd_only=true<CR>', opts)
  vim.keymap.set('n', '<C-p>', ':Telescope git_files<CR>', opts)
  vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', opts)
  vim.keymap.set('n', '<C-b>', ':Telescope buffers<CR>', opts)
  vim.keymap.set('n', '<C-y>', diff_files, opts)

  vim.keymap.set('n', '-', ':Telescope file_browser<CR>', opts)

  vim.keymap.set('', 'n', '<Plug>(is-n)zzzv', opts)
  vim.keymap.set('', 'N', '<Plug>(is-N)zzzv', opts)
  vim.keymap.set('', '*', '<Plug>(is-*)', opts)
  vim.keymap.set('', '#', '<Plug>(is-#)', opts)

  vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', opts)
  vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', opts)
  vim.keymap.set('n', '<leader>tt', ':TestLast<CR>', opts)

  vim.keymap.set('n', '<leader>W', ':%bd!<CR>', opts)
  vim.keymap.set('n', '<leader>w', ':%bd!|e#|bd!#<CR>', opts)

  vim.keymap.set('', '<leader>gy', ':GBrowse!<CR>', opts)

  vim.keymap.set('n', ']c', '<cmd>Gitsigns next_hunk<CR>', opts)
  vim.keymap.set('n', '[c', '<cmd>Gitsigns prev_hunk<CR>', opts)
  vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', opts)
  vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns reset_hunk<CR>', opts)

  vim.keymap.set('n', '<leader>cn', ':cnext<CR>', opts)
  vim.keymap.set('n', '<leader>cN', ':cprevious<CR>', opts)

  vim.keymap.set('n', '<leader>gy', ':GBrowse<CR>', opts)

  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

  vim.keymap.set('i', '<C-j>', function()
    require('luasnip').change_choice(1)
  end, opts)

  for _, m in pairs { 'i', 'v', 's' } do
    vim.keymap.set(m, '<C-Space>i', '<Plug>(sq-connect-insert-id)', opts)
    vim.keymap.set(m, '<C-Space>l', '<Plug>(sq-connect-insert-location-id)', opts)
    vim.keymap.set(m, '<C-Space>m', '<Plug>(sq-connect-insert-merchant-id)', opts)
    vim.keymap.set(m, '<C-Space>c', '<Plug>(sq-connect-insert-customer-id)', opts)
  end
end

function Keymaps.setup_lsp(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
  vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
  vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', opts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<C-j>', ':Telescope lsp_document_symbols<CR>', opts)
end

return Keymaps
