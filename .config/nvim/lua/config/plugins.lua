return {
  { import = 'config.plugins.hidden' },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'MarcWeber/vim-addon-local-vimrc' },
  {
    'haya14busa/is.vim',
    keys = {
      { 'n', '<Plug>(is-n)zzzv', silent = true },
      { 'N', '<Plug>(is-N)zzzv', silent = true },
      { '*', '<Plug>(is-*)', silent = true },
      { '#', '<Plug>(is-#)', silent = true },
    },
  },
  {
    'vim-test/vim-test',
    keys = {
      { '<leader>tn', '<cmd>TestNearest<cr>', silent = true },
      { '<leader>tf', '<cmd>TestFile<cr>', silent = true },
      { '<leader>tt', '<cmd>TestLast<cr>', silent = true },
    },
    init = function()
      vim.cmd([[
        let test#custom_runners = {'java':['Bazeltest']}
      ]])
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_theme = 'light'
    end,
  },
  {
    'RRethy/vim-illuminate',
    lazy = true,
    init = function()
      vim.g.Illuminate_delay = 500
      vim.diagnostic.config {
        virtual_text = false,
      }
    end,
  },
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = function()
      local state = {}
      local function debounce(key, wait)
        local timer = vim.loop.new_timer()
        timer:start(wait, 0, function()
          timer:stop()
          timer:close()
          state[key] = nil
        end)

        local existing_timer = state[key]
        state[key] = timer

        if existing_timer then
          existing_timer:stop()
          existing_timer:close()
          return false
        end

        return true
      end

      return {
        progress = {
          display = {
            done_ttl = 1,
            progress_icon = { pattern = 'dots_snake', period = 1 },
            progress_ttl = 5,
            format_message = function(msg)
              local default_fn = require('fidget.progress.display').default_format_message
              local key = msg.token .. '+' .. (msg.title or '') .. '+' .. (msg.message or '')
              if debounce(key, 1000) then
                return default_fn(msg)
              end
            end,
          },
        },
      }
    end,
  },
  {
    'treywood/kulala.nvim',
    dev = true,
    opts = {
      scratchpad_default_contents = {
        '### @name first',
        'GET https://httpbingo.org/get?foo=bar',
        '',
        '### @name second',
        'POST https://httpbingo.org/post',
        'Content-Type: application/json',
        '',
        '{"name":"Trey"}',
      },
      treesitter = true,
    },
  },
}
