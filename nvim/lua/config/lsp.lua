local util = require('util')

local function get_capabilities()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), capabilities)
end

local function create_format_autocmd(bufnr, config)
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    callback = function()
      local cmd_str = 'silent %!' .. config.format.cmd

      if config.format.args then
        for _, arg in ipairs(config.format.args) do
          if arg == '$FILENAME' then
            arg = vim.fn.expand('%')
          end
          cmd_str = cmd_str .. ' ' .. arg
        end
      end

      local saved_view = vim.fn.winsaveview()
      vim.cmd(cmd_str)
      if vim.v.shell_error ~= 0 then
        local error_str = vim.fn.join(vim.fn.getline(1, '$'), '\n')
        print('format error: ' .. error_str)
        vim.cmd('silent undo')
      end
      vim.fn.winrestview(saved_view)
    end,
  })
end

local function on_attach(client, bufnr)
  require('illuminate').on_attach(client)

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
  vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
  vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', opts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>rn', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true, buffer = bufnr })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<C-j>', ':Telescope lsp_document_symbols<CR>', opts)
end

local lsp_group = vim.api.nvim_create_augroup('language_servers', {})

local function setup(config)
  local default_config = {
    on_attach = on_attach,
    capabilities = get_capabilities(),
    root_dir = util.root_pattern { '.git' },
    flags = {
      debounce_text_changes = 150,
    },
  }

  config = vim.tbl_deep_extend('force', default_config, config)
  vim.api.nvim_create_autocmd('FileType', {
    group = lsp_group,
    pattern = config.filetypes,
    callback = function(args)
      if config.format then
        create_format_autocmd(args.buf, config)
      end
      vim.lsp.start(config)
    end,
  })
end

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local handle = vim.loop.fs_scandir(vim.fn.stdpath('config') .. '/lua/config/lsp')
    while handle do
      local name, type = vim.loop.fs_scandir_next(handle)

      if not name then
        break
      end

      if type == 'file' then
        local mod = 'config.lsp.' .. name:gsub('.lua', '')
        local ok, configs = pcall(require, mod)

        if ok then
          if not util.is_list(configs) then
            configs = { configs }
          end
          for _, config in pairs(configs) do
            setup(config)
          end
        else
          print('failed loading lsp config: ' .. mod)
        end
      end
    end
  end,
})

vim.api.nvim_create_user_command('LspRestart', function()
  local lsp_clients = vim.lsp.buf_get_clients()
  for _, client in pairs(lsp_clients) do
    local config = client.config
    local function restart()
      if client.is_stopped() then
        vim.lsp.start(config)
      else
        vim.defer_fn(restart, 500)
      end
    end

    client.stop()
    vim.defer_fn(restart, 500)
  end
end, {})
