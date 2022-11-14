(fn setup! [name config]
  `((. (require ,name) :setup) ,config))

(fn cfg! [name ...]
  `(let [tbl# [,name]
         opts# [,...]]
     (each [i# v# (ipairs opts#)]
       (let [next-i# (+ i# 1)]
         (if (= (% i# 2) 1)
             (tset tbl# v# (. opts# next-i#)))))
     tbl#))

(fn au! [...]
  `(vim.api.nvim_create_autocmd ,...))

(fn => [...]
  `(fn []
     ,...))

(fn use! [...]
  `(use (cfg! ,...)))

(fn packer! [...]
  `(packer.startup (=> ,...)))

(fn dig! [obj ...]
  `(do
     (var tgt# ,obj)
     (each [_# k# (ipairs [,...])]
       (set tgt# (. tgt# k#)))
     tgt#))

{: setup! : cfg! : au! : use! : packer! : dig! : =>}
