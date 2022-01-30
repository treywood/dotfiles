--vim.o.nocompatible=true

require'plugins'

--filetype plugin indent on

-- General Settings --
vim.o.backspace='indent,eol,start'
vim.o.tabstop=2
vim.o.shiftwidth=2
vim.o.ruler=true
vim.o.number=true
vim.o.showcmd=true
vim.o.incsearch=true
vim.o.hlsearch=true
vim.o.cursorline=true
vim.o.path=os.getenv("PWD").."/**"
vim.o.encoding="UTF-8"
vim.o.completeopt="menu,menuone,noselect"
vim.o.termguicolors=true

vim.g.mapleader = ','

vim.o.background='dark'
vim.g.material_style = 'palenight'
require'material'.setup {
  disable = {
    background = true,
  }
}
vim.cmd [[
colorscheme material

hi Normal guibg=#292D3E ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=#292D3E ctermbg=NONE
hi EndOfBuffer guibg=#292D3E ctermbg=NONE

hi TSType guifg=#ffcb6b
hi TSKeyword guifg=#C792EA
hi TSKeywordReturn guifg=#C792EA
hi TSVariable guifg=White
hi TSVariableBuiltin guifg=#C792EA
hi TSParameter guifg=#A6ACCD
hi TSInclude guifg=#C792EA
hi TSProperty guifg=White
hi TSOperator guifg=White
hi TSTagAttribute guifg=White
hi TSStringRegex guifg=#C3E88D
hi TSOperator guifg=#a6accd

hi rubyTSSymbol guifg=#f5a790
hi rubyTSLabel guifg=White
hi rubyTSException guifg=#C792EA

hi javascriptTSConstructor guifg=#ffcb6b 
]]

--function! StatusLine(current, width)
--  let l:s = ''
--
--  if a:current
--    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
--  else
--    let l:s .= '%#CrystallineInactive#'
--  endif
--  let l:s .= ' %f%h%w%m%r '
--  if a:current
--    let l:s .= crystalline#right_sep('', 'Fill') . '  %{fugitive#head()}'
--  endif
--
--  let l:s .= '%='
--  if a:current
--    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
--    let l:s .= crystalline#left_mode_sep('')
--  endif
--  if a:width > 80
--    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
--  else
--    let l:s .= ' '
--  endif
--
--  return l:s
--endfunction
--
--function! TabLine()
--  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
--  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
--endfunction
--
--let g:crystalline_enable_sep = 1
--let g:crystalline_statusline_fn = 'StatusLine'
--let g:crystalline_tabline_fn = 'TabLine'
--let g:crystalline_theme = 'onedark'

--set showtabline=2
--set guioptions-=e
--set laststatus=2

vim.g.fzf_layout = { down = '40%' }

--augroup fmt
--  autocmd!
--  au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
--augroup END
--let g:neoformat_enabled_haskell = ['hfmt']
--let g:neoformat_enabled_ruby = []

local opts = { silent = true, noremap = true }
vim.api.nvim_set_keymap('n','<C-e>',':History<CR>', opts)
vim.api.nvim_set_keymap('n','<C-p>',':GFiles<CR>', opts)
vim.api.nvim_set_keymap('n','<C-f>',':Rg<CR>', opts)
vim.api.nvim_set_keymap('n','<C-j>',':SymbolsOutline<CR>', opts)
vim.api.nvim_set_keymap('n','<C-b>',':Buffers<CR>', opts)

vim.cmd "let g:incsearch#auto_nohlsearch=1"
vim.api.nvim_set_keymap('n','/','<Plug>(incsearch-forward)', opts)
vim.api.nvim_set_keymap('n','?','<Plug>(incsearch-backward)', opts)
vim.api.nvim_set_keymap('n','g/','<Plug>(incsearch-stay)', opts)
vim.api.nvim_set_keymap('n','n','<Plug>(incsearch-nohl-n)', opts)
vim.api.nvim_set_keymap('n','N','<Plug>(incsearch-nohl-N)', opts)
vim.api.nvim_set_keymap('n','*','<Plug>(incsearch-nohl-*)', opts)
vim.api.nvim_set_keymap('n','#','<Plug>(incsearch-nohl-#)', opts)
vim.api.nvim_set_keymap('n','g*','<Plug>(incsearch-nohl-g*)', opts)
vim.api.nvim_set_keymap('n','g#','<Plug>(incsearch-nohl-g#)', opts)

vim.g.webdevicons_enable_nerdtree = 1
vim.g.webdevicons_conceal_nerdtree_brackets = 1

vim.api.nvim_set_keymap('n','=',':NERDTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n','-',':NERDTreeFind<CR>', opts)

vim.api.nvim_set_keymap('n','<leader>t',':call RunNearestSpec()<CR>', opts)
vim.api.nvim_set_keymap('n','<leader>r',':call RunLastSpec()<CR>', opts)

require'lspfuzzy'.setup{}
vim.g.symbols_outline = {
  relative_width = false,
  width = 40,
}
local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>a', '<cmd>CodeActionMenu<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

end

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for _, lsp in ipairs(require'./lsp_servers') do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

if not nvim_lsp.emmet_ls then
  configs.emmet_ls = {
    default_config = {
      cmd = {'emmet-ls', '--stdio'};
      filetypes = {'html','css','html.handlebars'};
    };
  }
end
nvim_lsp.emmet_ls.setup { capabilities = capabilities, on_attach = on_attach }

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}
