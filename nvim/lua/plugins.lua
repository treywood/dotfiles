vim.cmd('packadd packer.nvim')
local packer = require('packer')

packer.init {
  git = {
    subcommands = {
      update = 'pull --ff-only --progress --rebase=false --autostash',
    },
  },
}

return packer.startup(function()
  use('wbthomason/packer.nvim')

  -- utility
  use('nvim-lua/plenary.nvim')

  -- find things
  use('haya14busa/is.vim')
  use('ggandor/leap.nvim')
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
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
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
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
  }

  -- LSP
  use('neovim/nvim-lspconfig')
  use('jose-elias-alvarez/null-ls.nvim')
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
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = '@function.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
            },
          },
        },
      }
      require('treesitter-context').setup {
        patterns = {
          ['ruby.rspec'] = {
            'do_block',
          },
          ruby = {
            'do_block',
          },
        },
      }
    end,
  }
  use { 'nvim-treesitter/playground', opt = true }

  -- documentation
  use('mracos/mermaid.vim')
  use {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    run = 'cd app && yarn install',
    setup = function()
      vim.g.mkdp_theme = 'light'
    end,
  }

  -- testing
  use('vim-test/vim-test')

  -- git
  use { 'tpope/vim-fugitive', requires = 'tpope/vim-rhubarb' }
  use {
    'lewis6991/gitsigns.nvim',
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
        header = vim.fn.system('fortune'),
        items = {
          starter.sections.sessions(5, true),
          starter.sections.recent_files(10, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet('· '),
          starter.gen_hook.padding(15),
          starter.gen_hook.aligning('left', 'center'),
        },
      }

      require('mini.sessions').setup()
      require('mini.pairs').setup()
      require('mini.surround').setup()
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
