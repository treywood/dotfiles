(fn setup! [name config]
  `((. (require ,name) :setup) ,config))

(fn args-tbl! [...]
  `(let [tbl# {}
         args# [,...]]
     (each [i# v# (ipairs args#)]
       (let [next-i# (+ i# 1)]
         (if (= (% i# 2) 1)
             (tset tbl# v# (. args# next-i#)))))
     tbl#))

(fn cfg! [name ...]
  `(vim.tbl_extend :keep [,name] (args-tbl! ,...)))

(fn au! [...]
  `(vim.api.nvim_create_autocmd ,...))

(fn => [...]
  `(fn []
     ,...))

(fn use! [...]
  `(use (cfg! ,...)))

(fn packer! [...]
  `(packer.startup (=>  
     (use! :wbthomason/packer.nvim)
     ,...)))

{: setup! : args-tbl! : cfg! : au! : use! : packer! : =>}
