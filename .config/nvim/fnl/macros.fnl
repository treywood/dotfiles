(fn setup! [name config]
  `((. (require ,name) :setup) ,config))

(fn cfg! [name opts]
  (if (= opts nil)
      name
      `(let [pkg# [,name]]
         (each [k# v# (pairs ,opts)]
           (tset pkg# k# v#))
         pkg#)))

(fn au! [...]
  `(vim.api.nvim_create_autocmd ,...))

(fn => [...]
  `(fn []
     ,...))

(fn use! [...]
  `(use (cfg! ,...)))

(fn packer! [...]
  `(packer.startup (=> ,...)))

{: setup! : cfg! : au! : use! : packer! : =>}
