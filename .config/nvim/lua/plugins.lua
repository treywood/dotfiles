vim.cmd "packadd packer.nvim"

return require'packer'.startup(function()
  use 'wbthomason/packer.nvim'

  use 'haya14busa/incsearch.vim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', run='make'}
    },
    config = function()
      local actions = require'telescope.actions'
      require'telescope'.setup {
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
            }
          }
        },
        extensions = {'fzf'}
      }
    end
  }

  use 'neovim/nvim-lspconfig'
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim',
  }
  use 'j-hui/fidget.nvim'

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
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'romgrk/nvim-treesitter-context',
    },
    config = function()
      local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
      parser_configs.norg_meta = {
        install_info = {
          url = 'https://github.com/nvim-neorg/tree-sitter-norg-meta',
          files = {'src/parser.c'},
          branch = 'main'
        },
      }
      parser_configs.norg_table = {
        install_info = {
          url = 'https://github.com/nvim-neorg/tree-sitter-norg-table',
          files = {'src/parser.c'},
          branch = 'main'
        },
      }

      require'nvim-treesitter.configs'.setup {
        ensure_installed = {'norg','norg_meta','norg_table'},
        highlight = { enable = true },
        endwise = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = "@function.outer",
              ['if'] = "@function.inner",
              ['ac'] = "@class.outer",
              ['ic'] = "@class.inner",
              ['ak'] = "@block.outer",
              ['ik'] = "@block.inner",
              ['ae'] = "@conditional.outer",
              ['ie'] = "@conditional.inner",
            }
          }
        }
      }
      require'treesitter-context'.setup {}
    end
  }
  use 'nvim-treesitter/playground'

  use {
    'echasnovski/mini.nvim',
    config = function()
      require'mini.comment'.setup {
        mappings = {
          comment = 'm',
          comment_line = 'mm',
          textobject = 'm',
        }
      }

      local starter = require'mini.starter'
      starter.setup {
        header = require'fortune'.header(),
        items = {
          starter.sections.sessions(5, true),
          starter.sections.recent_files(10, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet('· '),
          starter.gen_hook.padding(15),
          starter.gen_hook.aligning('left','center'),
        },
      }

      require'mini.sessions'.setup()
      require'mini.pairs'.setup()
      require'mini.surround'.setup()
    end
  }

  use 'mracos/mermaid.vim'
  use {'iamcco/markdown-preview.nvim', ft = 'markdown', run = 'cd app && yarn install' }

  use 'vim-test/vim-test'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'

  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require'gitsigns'.setup()
    end,
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      vim.cmd [[
        let g:nvim_tree_show_icons = {
          \ 'git': 1,
          \ 'folders': 1,
          \ 'files': 1,
          \ 'folder_arrows': 1,
          \ }

        let g:nvim_tree_icons = {
          \ 'default': '',
          \ 'symlink': '',
          \ 'git': {
          \   'unstaged': "✗",
          \   'staged': "✓",
          \   'unmerged': "",
          \   'renamed': "➜",
          \   'untracked': "★",
          \   'deleted': "",
          \   'ignored': "◌"
          \   },
          \ 'folder': {
          \   'arrow_open': "",
          \   'arrow_closed': "",
          \   'default': "",
          \   'open': "",
          \   'empty': "",
          \   'empty_open': "",
          \   'symlink': "",
          \   'symlink_open': "",
          \   }
          \ }
      ]]
      require'nvim-tree'.setup {
        filters = {
          dotfiles = true,
        },
        view = {
          mappings = {
            list = {
              { key = '-', action = 'close' },
            }
          }
        }
      }
    end
  }

  use 'sainnhe/everforest'
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      {'kyazdani42/nvim-web-devicons',opt=true},
    },
    config = function()
      require'lualine'.setup {
        options = {
          theme = 'everforest',
          disabled_filetypes = {'NvimTree'},
        },
        sections = {
          lualine_c = {{'filename', file_status=true, path=1}},
          lualine_x = {},
          lualine_y = {'filetype'}
        },
        tabline = {
          lualine_a = {'buffers'},
          lualine_z = {'tabs'}
        },
        extensions = {'fugitive','nerdtree'}
      }
    end
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.g.indent_blankline_filetype_exclude = {
        'starter',
        'packer',
        'nerdtree',
        'help',
      }
      vim.g.indent_blankline_buftype_exclude = {
        'nofile',
      }
      require("indent_blankline").setup {
        char = "",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
      }
    end
  }

  use {
    'nvim-neorg/neorg',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require'neorg'.setup {
        load = {
          ['core.defaults'] = {},
          ['core.norg.concealer'] = {
            config = {}
          },
          ['core.norg.qol.toc'] = {
            config = {}
          },
          ['core.norg.dirman'] = {
            config = {
              workspaces = {
                notes = '~/notes/',
              },
              autochdir = false,
            }
          },
          ['core.gtd.base'] = {
            config = {
              workspace = 'notes',
            }
          }
        }
      }
    end
  }
end)
