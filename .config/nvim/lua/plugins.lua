vim.cmd('packadd packer.nvim')

return require('packer').startup(function()
  use('wbthomason/packer.nvim')

  -- search
  use('haya14busa/incsearch.vim')
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
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
        },
      }

      require('telescope').load_extension('fzf')
    end,
  }

  -- LSP
  use('neovim/nvim-lspconfig')
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim',
  }
  use('j-hui/fidget.nvim')
  use('RRethy/vim-illuminate')

  -- completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
    },
  }

  -- syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'romgrk/nvim-treesitter-context',
      'andymass/vim-matchup',
    },
    config = function()
      require('orgmode').setup_ts_grammar()

      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'org', 'http', 'json' },
        highlight = {
          enable = true,
          disable = { 'org' },
          additional_vim_regex_highlighting = { 'org' },
        },
        endwise = { enable = true },
        matchup = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ak'] = '@block.outer',
              ['ik'] = '@block.inner',
              ['ae'] = '@conditional.outer',
              ['ie'] = '@conditional.inner',
            },
          },
        },
      }
      require('treesitter-context').setup {}
    end,
  }
  use('nvim-treesitter/playground')

  -- documentation
  use('mracos/mermaid.vim')
  use { 'iamcco/markdown-preview.nvim', ft = 'markdown', run = 'cd app && yarn install' }

  -- testing
  use('vim-test/vim-test')

  -- git
  use('tpope/vim-fugitive')
  use('tpope/vim-rhubarb')
  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  }

  -- misc
  use {
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
        header = require('fortune').header(),
        items = {
          starter.sections.sessions(5, true),
          starter.sections.recent_files(10, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet('· '),
          starter.gen_hook.padding(15),
          starter.gen_hook.aligning('left', 'center'),
        },
        query_updaters = [[abcdefghijklmnopqrstuvwxyz0123456789_.]],
      }

      require('mini.sessions').setup()
      require('mini.pairs').setup()
      require('mini.surround').setup()
    end,
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        filters = {
          dotfiles = true,
        },
        view = {
          mappings = {
            list = {
              { key = '-', action = 'close' },
            },
          },
        },
        renderer = {
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = false,
            },
            glyphs = {
              default = '',
              symlink = '',
              git = {
                unstaged = '✗',
                staged = '✓',
                unmerged = '',
                renamed = '➜',
                untracked = '★',
                deleted = '',
                ignored = '◌',
              },
              folder = {
                default = '',
                open = '',
                empty = '',
                empty_open = '',
                symlink = '',
                symlink_open = '',
              },
            },
          },
        },
      }
    end,
  }

  -- theme
  use('sainnhe/everforest')
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true },
    },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'everforest',
          disabled_filetypes = { 'NvimTree' },
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
        extensions = { 'fugitive' },
      }
    end,
  }

  -- org
  use {
    'nvim-orgmode/orgmode',
    config = function()
      require('orgmode').setup {
        org_agenda_files = { '~/notes/*' },
        org_agenda_templates = {
          t = { description = 'Task', template = '* %?\n  %t' },
        },
        org_default_notes_file = '~/notes/refile.org',
      }
    end,
  }

  local ok, setup = pcall(require, 'local_plugins')
  if ok then
    setup(use)
  end
end)
