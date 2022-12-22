return {
  'nvim-lua/plenary.nvim',
  'haya14busa/is.vim',
  'ggandor/leap.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local lga_actions = require('telescope-live-grep-args.actions')

      telescope.setup {
        defaults = {
          layout_strategy = 'bottom_pane',
          layout_config = {
            height = 0.4,
            prompt_position = 'bottom',
          },
          selection_caret = '  ',
          mappings = {
            i = {
              ['<C-n>'] = false,
              ['<C-p>'] = false,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-c>'] = false,
              ['<Esc>'] = actions.close,
            },
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<C-w>'] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          'fzf',
          live_grep_args = {
            mappings = {
              i = {
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-l>'] = lga_actions.quote_prompt(),
              },
            },
          },
        },
      }

      telescope.load_extension('fzf')
      telescope.load_extension('live_grep_args')
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup {
        actions = {
          change_dir = {
            enable = false,
          },
        },
        filters = {
          dotfiles = true,
        },
        renderer = {
          icons = {
            show = {
              folder_arrow = false,
            },
          },
        },
        view = {
          adaptive_size = true,
          mappings = {
            list = {
              { key = '-', action = 'close' },
            },
          },
        },
      }
    end,
  },
  'hrsh7th/cmp-nvim-lsp',
  'mracos/mermaid.vim',
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_theme = 'light'
    end,
  },
  'vim-test/vim-test',
  { 'tpope/vim-fugitive', dependencies = 'tpope/vim-rhubarb' },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.comment').setup {
        mappings = {
          comment = 'm',
          comment_line = 'mm',
          textobject = 'm',
        },
      }

      local starter = require('mini.starter')
      starter.setup {
        header = vim.fn.system('fortune'),
        items = {
          starter.sections.recent_files(10, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet('· '),
          starter.gen_hook.padding(15),
          starter.gen_hook.aligning('left', 'center'),
        },
      }

      require('mini.pairs').setup()
      require('mini.surround').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'everforest',
          disabled_filetypes = {
            statusline = { 'NvimTree' },
          },
        },
        sections = {
          lualine_b = { { 'branch', icon = '' } },
          lualine_c = { { 'filename', file_status = true, path = 1 } },
          lualine_x = {},
          lualine_y = { 'filetype' },
        },
        tabline = {
          lualine_a = { { 'tabs', mode = 1 } },
          lualine_z = {},
        },
        extensions = {
          {
            filetypes = { 'fugitive' },
            sections = {
              lualine_a = { { 'branch', icon = '' } },
            },
          },
        },
      }
    end,
  },
}
