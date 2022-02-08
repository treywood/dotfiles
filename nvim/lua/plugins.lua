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

			--require'telescope'.load_extension('fzf')
			require'telescope'.setup {
				defaults = {
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
	use '~/.config/nvim/lsp-servers.nvim'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'

	use 'sbdchd/neoformat'
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = {
			'RRethy/nvim-treesitter-endwise',
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			require'nvim-treesitter.configs'.setup {
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
		end
	}
	use 'nvim-treesitter/playground'
	use 'jiangmiao/auto-pairs'

	use 'vim-test/vim-test'

	use 'tpope/vim-fugitive'
	use {
		'pwntester/octo.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'kyazdani42/nvim-web-devicons',
		},
		config = function ()
			require'octo'.setup {
				mappings = {
					pull_request = {
						add_comment = '<leader>ca',
						delete_comment = '<leader>cd',
					},
					review_thread = {
						add_comment = '<leader>ca',
						add_suggestion = '<leader>sa',
						delete_comment = '<leader>cd',
					},
					review_diff = {
						add_review_comment = '<leader>ca',
						add_review_suggestion = '<leader>sa',
					}
				}
			}
		end
	}
	use 'airblade/vim-gitgutter'

	use {
		'preservim/nerdtree',
		requires = {'Xuyuanp/nerdtree-git-plugin','ryanoasis/vim-devicons'},
		config = function()
			vim.g.webdevicons_enable_nerdtree = 1
			vim.g.webdevicons_conceal_nerdtree_brackets = 1
		end
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = {
			{'kyazdani42/nvim-web-devicons',opt=true},
			'sainnhe/everforest',
		},
		config = function()
			-- vim.g.material_style = 'palenight'
			-- vim.g.material_lualine_style = 'default'
			-- require'material'.setup { disable = { background=true } }
			vim.g.everforest_background = 'hard'
			vim.g.everforest_disable_italic_comment = 1
			require'lualine'.setup {
				options = {
					theme = 'everforest'
				},
				sections = {
					lualine_c = {{'filename', file_status=true, path=1}},
					lualine_x = {},
					lualine_y = {'filetype'}
				},
				tabline = {
					lualine_a = {
						{
							'buffers',
							filetype_names = {
								octo = 'Octo'
							}
						}
					},
					lualine_z = {'tabs'}
				},
				extensions = {'fugitive','nerdtree'}
			}
		end
	}
end)
