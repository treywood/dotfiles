return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
      'romgrk/nvim-treesitter-context',
      'andymass/vim-matchup',
    },
    config = function()
      local parsers = { 'vim', 'lua', 'query', 'python', 'bash', 'http', 'json', 'markdown', 'markdown_inline' }

      -- Language aliases for treesitter
      vim.treesitter.language.register('proto', 'protobuf')

      local treesitter = require('nvim-treesitter')
      treesitter.setup()
      treesitter.install(parsers)

      local group = vim.api.nvim_create_augroup('config_treesitter', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select = require('nvim-treesitter-textobjects.select')
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select.select_textobject('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select.select_textobject('@function.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ak', function()
        select.select_textobject('@block.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ik', function()
        select.select_textobject('@block.inner', 'textobjects')
      end)

      local move = require('nvim-treesitter-textobjects.move')
      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']r', function()
        move.goto_next_start('@request', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[r', function()
        move.goto_previous_start('@request', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end)

      require('treesitter-context').setup {
        patterns = {
          ruby = {
            'do_block',
          },
        },
      }
    end,
  },
}
