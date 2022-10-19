pcall(require, 'sq-connect-repl.completion')

vim.diagnostic.config {
  virtual_text = false,
}

vim.g.Illuminate_delay = 500

-- Setup nvim-cmp.
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

local has_words_before = function()
  ---@diagnostic disable-next-line: deprecated
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<CR>'] = cmp.mapping.confirm { select = false },
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format {
      mode = 'symbol_text',
    },
  },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

cmp.setup.filetype('http', {
  sources = cmp.config.sources {
    { name = 'luasnip' },
    { name = 'sq-connect-repl.locations' },
  },
})

local lspKinds = require('cmp.types').lsp.CompletionItemKind
cmp.setup.filetype('TelescopePrompt', {
  enabled = true,
  completion = { autocomplete = false },
  sources = cmp.config.sources {
    {
      name = 'path',
      option = {
        get_cwd = function()
          return vim.fn.getcwd()
        end,
      },
      entry_filter = function(entry)
        return lspKinds[entry:get_kind()] == 'Folder'
      end,
    },
  },
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local have_servers, servers = pcall(require, 'lsp_servers')
if have_servers then
  local nvim_lsp = require('lspconfig')

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    require('keymaps').setup_lsp(bufnr)
    require('illuminate').on_attach(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  for _, lsp in ipairs(servers) do
    local lsp_name = lsp
    local config = {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }

    if type(lsp) == 'table' then
      lsp_name = table.remove(lsp, 1)
      config = vim.tbl_deep_extend('force', config, lsp)
    end

    nvim_lsp[lsp_name].setup(config)
  end
end

local have_sources, sources = pcall(require, 'null_ls_sources')
if have_sources then
  require('null-ls').setup {
    debug = true,
    sources = sources,
    on_attach = function(client, bufnr)
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
      end
    end,
  }
end

require('fidget').setup {
  text = {
    spinner = 'dots_snake',
  },
}
