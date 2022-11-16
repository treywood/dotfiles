(local pickers (require :telescope.pickers))
(local finders (require :telescope.finders))
(local conf (. (require :telescope.config) :values))

(fn diff-files [o]
  (let [opts (or o {})
        base_branch (or opts.base_branch :master)]
    (set opts.cache_picker false)
    (: (pickers.new opts
                    {:prompt_title "Git Diff Files"
                     :finder (finders.new_oneshot_job [:git :diff :--name-only base_branch])
                     :sorter (conf.file_sorter opts)
                     :previewer (conf.file_previewer opts)}) :find)
    ))

:return diff-files

