-- Plugins are managed by |vim.pack|: cloned into `stdpath('data')/site/pack/core/opt`
-- and pinned to exact revisions in `nvim-pack-lock.json` next to this config.
-- Update everything with `:lua vim.pack.update()`; a single plugin with
-- `:lua vim.pack.update({ 'telescope.nvim' })`.

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Build hooks. Registered before the first `vim.pack` call so they also fire
-- on a cold install (including the bulk install done from the lockfile).
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('config_pack_build', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == 'telescope-fzf-native.nvim' and ev.data.kind ~= 'delete' then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.g.diffs = {
  extra_filetypes = { 'diff' },
  highlights = {
    treesitter = { max_lines = 1000 },
    vim = { max_lines = 500 },
  },
}

vim.pack.add {
  -- libraries
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-tree/nvim-web-devicons'),

  -- ui
  gh('sainnhe/everforest'),
  gh('nvim-lualine/lualine.nvim'),
  gh('echasnovski/mini.starter'),
  gh('RRethy/vim-illuminate'),

  -- editing
  gh('echasnovski/mini.bracketed'),
  gh('echasnovski/mini.pairs'),
  gh('echasnovski/mini.surround'),

  -- git
  gh('tpope/vim-fugitive'),
  gh('tpope/vim-rhubarb'),
  gh('barrettruth/diffs.nvim'),
  gh('echasnovski/mini.diff'),

  -- telescope
  gh('nvim-telescope/telescope.nvim'),
  gh('nvim-telescope/telescope-fzf-native.nvim'),
  gh('nvim-telescope/telescope-live-grep-args.nvim'),

  -- treesitter. `main` carries the setup()/install() API that
  -- config.plugins.treesitter targets; pinned so that an upstream default
  -- branch change can't silently swap in the incompatible `master` API.
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
  gh('romgrk/nvim-treesitter-context'),

  -- misc
  gh('vim-test/vim-test'),
  gh('MarcWeber/vim-addon-local-vimrc'),

  -- local checkout. vim.pack clones rather than symlinks, so this is a
  -- snapshot of the last commit: after editing ~/Development/blox.nvim,
  -- commit and run `:lua vim.pack.update({ 'blox.nvim' })` to pick it up.
  { src = 'file:///Users/treyw/Development/blox.nvim' },
}

require('config.plugins.blox')
require('config.plugins.diffs')
require('config.plugins.everforest')
require('config.plugins.git')
require('config.plugins.illuminate')
require('config.plugins.lualine')
require('config.plugins.mini')
require('config.plugins.mini-diff')
require('config.plugins.telescope')
require('config.plugins.treesitter')
require('config.plugins.vim-test')
