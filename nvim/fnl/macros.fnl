(fn setup! [name config]
  `((. (require ,name) :setup) ,config))

(fn opt! [name opts]
  (if (= opts nil)
      name
      `(let [plg# [,name]]
         (each [k# v# (pairs ,opts)]
           (tset plg# k# v#))
         plg#)))

(fn au! [...]
  `(vim.api.nvim_create_autocmd ,...))

(fn => [...]
  `(fn []
     ,...))

(fn use! [...]
  `(use (opt! ,...)))

(fn packer! [...]
  `(packer.startup (=> ,...)))

{: setup! : opt! : au! : use! : packer! : =>}
