Keymaps = {}

function Keymaps.setup()
  local opts = { silent = true }
  vim.keymap.set('n', '<esc>', '<cmd>nohl<CR><esc>')

  vim.keymap.set('n', '<leader>W', ':%bd!<CR>', opts)
  vim.keymap.set('n', '<leader>w', ':%bd!|e#|bd!#<CR>', opts)

  vim.keymap.set('n', '<leader>cn', ':cnext<CR>', opts)
  vim.keymap.set('n', '<leader>cN', ':cprevious<CR>', opts)

  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

  vim.keymap.set('i', '<C-j>', "<cmd>lua require('luasnip').change_choice(1)", opts)
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
