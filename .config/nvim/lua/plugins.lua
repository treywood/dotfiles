vim.cmd "packadd packer.nvim"

return require'packer'.startup(function()
	use 'wbthomason/packer.nvim'

	use 'haya14busa/incsearch.vim'
	use 'junegunn/fzf'
	use 'junegunn/fzf.vim'
	use 'ojroques/nvim-lspfuzzy'
	
	use 'simrat39/symbols-outline.nvim'
	use 'neovim/nvim-lspconfig'

	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use 'weilbith/nvim-code-action-menu'

	use 'sbdchd/neoformat'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'nvim-treesitter/playground'
	use 'jiangmiao/auto-pairs'

	use 'tpope/vim-rails'
	use 'thoughtbot/vim-rspec'
	
	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'
	use 'airblade/vim-gitgutter'

	use 'preservim/nerdtree'
	use 'Xuyuanp/nerdtree-git-plugin'
	use 'ryanoasis/vim-devicons'

	use 'marko-cerovac/material.nvim'
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
end)
