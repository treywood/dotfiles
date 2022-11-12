(import-macros {: au! : =>} :macros)

(local Kitty (require :kitty))

(au! :User
     {:pattern :MiniStarterOpened
      :callback (fn [args]
                  (local MiniStarter (require :mini.starter))

                  (fn next-item []
                    (MiniStarter.update_current_item :next))

                  (fn prev-item []
                    (MiniStarter.update_current_item :prev))

                  (local options {:buffer args.buf})
                  (vim.keymap.set :n :<C-j> next-item options)
                  (vim.keymap.set :n :<C-k> prev-item options)
                  (vim.keymap.set :n :<C-p> ":Telescope git_files<CR>" options)
                  (vim.keymap.set :n "-" ":NvimTreeToggle<CR>" options))})

(au! [:BufReadPre :BufNewFile]
     {:pattern :**/spec/**/*_spec.rb
      :callback (fn []
                  (vim.schedule (fn []
                                  (vim.cmd "setfiletype ruby.rspec"))))})

(when (Kitty.is-kitty)
  (local kitty-window-id (os.getenv :KITTY_WINDOW_ID))

  (fn set-tab-title [tab-title]
    (Kitty.remote [:set-tab-title
                   :--match
                   (.. "window_id:" kitty-window-id)
                   tab-title]))

  (when (= (vim.fn.argc) 0)
    (au! :VimEnter
         {:callback (fn []
                      (let [git-command "git remote get-url --all origin | sed -E 's/.+\\/(.+)\\.git$/\\1/'"
                            repo-name (-> (vim.fn.system git-command)
                                          (: :gsub "%s*$" ""))
                            dir-name (-> (vim.fn.getcwd)
                                         (: :gsub ".+/" ""))
                            tab-name (if (not= vim.v.shell_error 0)
                                         (string.format "nvim (%s)" dir-name)
                                         (not= repo-name nil)
                                         (string.format "nvim (%s)" repo-name))]
                        (set-tab-title tab-name)))})
    (au! :VimLeave {:callback (=> (set-tab-title nil))})
    (au! :BufWritePre
         {:pattern :kitty.conf :callback (=> (Kitty.reload-config))})))
