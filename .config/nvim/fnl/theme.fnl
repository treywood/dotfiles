(import-macros {: args-tbl!} :macros)
(set vim.o.background :dark)

(set vim.g.everforest_background :hard)
(set vim.g.everforest_disable_italic_comment 1)
(set vim.g.everforest_diagnostic_text_highlight 1)

(vim.cmd "colorscheme everforest")

(macro hi! [name ...]
  `(let [opts# (args-tbl! ,...)]
     (vim.api.nvim_set_hl 0 ,name opts#)))

(macro hi-link! [name target]
  `(hi! ,name :link ,target))

(hi! :Gray :fg "#a7b0a4")
(hi! :GreenBold :fg "#a7c080" :bold true)

(hi-link! :TSParameter :Gray)
(hi-link! :TSOperator :Gray)
(hi-link! :TSField :TSVariable)

(hi-link! "@symbol.ruby" :Orange)
(hi-link! "@label.ruby" "@variable")

(hi-link! "@field.yaml" :Orange)
(hi-link! :yamlBlockMappingKey :Orange)
(hi-link! :yamlPlainScalar :String)
(hi-link! :yamlBlockCollectionItemStart :Gray)

(hi-link! "@label.json" :Orange)
(hi-link! "@string.json" :TSString)

(hi-link! "@property.go" :TSField)
(hi-link! "@property.javascript" :TSField)

(hi-link! :GitSignsAdd :GreenSign)
(hi-link! :GitSignsChange :OrangeSign)
(hi-link! :GitSignsDelete :RedSign)

(hi-link! :MiniStarterHeader :Green)
(hi-link! :MiniStarterSection :Red)
(hi-link! :MiniStarterItem :Gray)
(hi-link! :MiniStarterItemBullet :GreenBold)
(hi-link! :MiniStarterItemPrefix :GreenBold)
(hi-link! :MiniStarterQuery :Orange)
(hi-link! :MiniStarterFooter :Gray)

(hi-link! :DevIconRb :Red)

(hi-link! :NvimTreeGitDirty :Orange)
(hi-link! :NvimTreeFolderIcon :Yellow)

(vim.cmd "hi ErrorText gui=none")
(vim.cmd "hi WarningText gui=none")
(vim.cmd "hi HintText gui=none")
(vim.cmd "hi InfoText gui=none")
