(local Job (require :plenary.job))
(local Kitty {})

(local kitty-listen-on (os.getenv :KITTY_LISTEN_ON))
(local kitty-pid (os.getenv :KITTY_PID))

(fn Kitty.run [args in-opts]
  (print (string.format "kitty %s" (table.concat args " ")))
  (local default-opts
         {:cwd (vim.fn.getcwd)
          :command :kitty
          : args
          :on_stderr (fn [_ err]
                       (print (string.format "Kitty error: %s" err)))})
  (local opts (vim.tbl_deep_extend :keep default-opts (or in-opts {})))
  (: (Job:new opts) :start))

(fn Kitty.remote [args opts]
  (local remote-args ["@" (.. :--to= kitty-listen-on)])
  (each [_ v (ipairs args)]
    (table.insert remote-args v))
  (Kitty.run remote-args opts))

(fn Kitty.is-kitty []
  (not= kitty-pid nil))

(fn Kitty.reload-config []
  (local job (Job:new {:cwd (vim.fn.getcwd)
                       :command :kill
                       :args [:-s :SIGUSR1 kitt-pid]
                       :on_stderr (fn [_ err]
                                    (print (string.format "error reloading kitty config: %s"
                                                          err)))}))
  (job:start))

:return

Kitty
