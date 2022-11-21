(import-macros {: setup! : cfg! : args-tbl! : use! : packer! : =>} :macros)
(local packer (require :packer))

(packer.init {:git {:subcommands {:update "pull --ff-only --progress --rebase=false --autostash"}}})

(packer!
  (use! :rktjmp/hotpot.nvim)
  (use! :nvim-lua/plenary.nvim)
  (use! :haya14busa/is.vim)
  (use! :ggandor/leap.nvim)
  (use! :nvim-telescope/telescope.nvim
        :requires [:nvim-telescope/telescope-live-grep-args.nvim
                   (cfg! :nvim-telescope/telescope-fzf-native.nvim :run :make)]
        :config (=> (let [telescope (require :telescope)
                          actions (require :telescope.actions)
                          lga_actions (require :telescope-live-grep-args.actions)]
                      (telescope.setup {:defaults {
                                        :layout_strategy :bottom_pane
                                        :layout_config {:height 0.4 :prompt_position :bottom}
                                        :selection_caret "  "
                                        :mappings {:i {:<C-n> false
                                                       :<C-p> false
                                                       :<C-c> false
                                                       :<C-j> actions.move_selection_next
                                                       :<C-k> actions.move_selection_previous
                                                       :<Esc> actions.close}}}
                                        :pickers {:buffers {:mappings {:i {:<C-w> actions.delete_buffer}}}}
                                        :extensions (doto [:fzf]
                                                      (tset :live_grep_args
                                                            {:mappings {:i {:<C-k> actions.move_selection_previous
                                                                            :<C-l> (lga_actions.quote_prompt)}}}))})
                      (telescope.load_extension :fzf)
                      (telescope.load_extension :live_grep_args))))
  (use! :nvim-tree/nvim-tree.lua
        :requires [:nvim-tree/nvim-web-devicons]
        :config (=> (setup! :nvim-tree {:actions {:change_dir {:enable false}}
                            :filters {:dotfiles true}
                            :renderer {:icons {:show {:folder_arrow false}}}
                            :view {:adaptive_size true :mappings {:list {:key "-" :action :close}}}})))
  (use! :neovim/nvim-lspconfig)
  (use! :jose-elias-alvarez/null-ls.nvim)
  (use! :j-hui/fidget.nvim :config (=> (setup! :fidget {:text {:spinner :dots_snake}})))
  (use! :RRethy/vim-illuminate :config (=> ((. (require :illuminate) :configure) {:filetypes_denylist [:NvimTree]})))
  (use! :hrsh7th/nvim-cmp
        :requires [:hrsh7th/cmp-nvim-lsp
                    :hrsh7th/cmp-buffer
                    :hrsh7th/cmp-path
                    :hrsh7th/cmp-cmdline
                    :L3MON4D3/LuaSnip
                    :saadparwaiz1/cmp_luasnip
                    :onsails/lspkind-nvim])
  (use! :nvim-treesitter/nvim-treesitter
        :run ":TSUpdate"
        :requires [:RRethy/nvim-treesitter-endwise
                    :nvim-treesitter/nvim-treesitter-textobjects
                    :romgrk/nvim-treesitter-context
                    :andymass/vim-matchup]
        :config (=> (setup! :nvim-treesitter.configs
                            {:ensure_installed [:http :json]
                             :highlight {:enable true}
                             :endwise {:enable true}
                             :matchup {:enable true}
                             :textobjects {:select {:enable true
                                                    :lookahead true
                                                    :keymaps {:af "@function.outer"
                                                              :if "@function.inner"
                                                              :ak "@block.outer"
                                                              :ik "@block.inner"}}
                                           :move {:enable true
                                                  :set_jumps true
                                                  :goto_next_start {"]f" "@function.outer"}
                                                  :goto_next_end {"]F" "@function.outer"}
                                                  :goto_previous_start {"[f" "@function.outer"}
                                                  :goto_previous_end {"[F" "@function.outer"}}}})
                    (setup! :treesitter-context {:patterns {:ruby.rspec [:do_block]}})))
  (use! :nvim-treesitter/playground :opt true)
  (use! :mracos/mermaid.vim)
  (use! :iamcco/markdown-preview.nvim
        :ft :markdown
        :run "cd app && yarn install"
        :config (=> (set vim.g.mkdp_theme :light)))
  (use! :vim-test/vim-test)
  (use! :tpope/vim-fugitive :requires [:tpope/vim-rhubarb])
  (use! :lewis6991/gitsigns.nvim :config (=> (setup! :gitsigns)))
  (use! :echasnovski/mini.nvim
        :config (=> (setup! :mini.comment {:mappings {:comment :m
                                                      :comment_line :mm
                                                      :textobject :m}})
                    (setup! :mini.pairs)
                    (setup! :mini.surround)
                    (let [starter (require :mini.starter)]
                      (starter.setup {:header (vim.fn.system :fortune)
                                     :items [(starter.sections.recent_files 10 true)]
                                     :content_hooks [(starter.gen_hook.adding_bullet "· ")
                                                     (starter.gen_hook.padding 15)
                                                     (starter.gen_hook.aligning :left :center)]}))))
  (use! :sainnhe/everforest)
  (use! :nvim-lualine/lualine.nvim
        :requires [(cfg! :kyazdani42/nvim-web-devicons :opt true)]
        :config (=> (let [branch (cfg! :branch :icon "")
                          tabs   (cfg! :tabs :mode 1)
                          filename (cfg! :filename :file_status true :path 1)]
                      (setup! :lualine {:options {:theme :everforest
                                                  :disabled_filetypes {:statusline [:NvimTree]}}
                                        :sections {:lualine_b [branch]
                                                   :lualine_c [filename]
                                                   :lualine_x []
                                                   :lualine_y [:filetype]}
                                        :tabline {:lualine_a [tabs]
                                                  :lualine_z []}
                                        :extensions [{:filetypes [:fugitive]
                                                      :sections {:lualine_a [branch]}}]}))))
  (let [(ok? setup) (pcall require :local-plugins)]
    (when ok? (setup use))))
