(set vim.o.background :dark)

(set vim.g.everforest_background :hard)
(set vim.g.everforest_disable_italic_comment 1)
(set vim.g.everforest_diagnostic_text_highlight 1)

(vim.cmd "colorscheme everforest")

(vim.api.nvim_set_hl 0 :Gray {:fg "#a7b0a4"})
(vim.api.nvim_set_hl 0 :GreenBold {:fg "#a7c080" :bold true})

(vim.api.nvim_set_hl 0 :TSParameter {:link :Gray})
(vim.api.nvim_set_hl 0 :TSOperator {:link :Gray})
(vim.api.nvim_set_hl 0 :TSField {:link :TSVariable})

(vim.api.nvim_set_hl 0 "@symbol.ruby" {:link :Orange})
(vim.api.nvim_set_hl 0 "@label.ruby" {:link "@variable"})

(vim.api.nvim_set_hl 0 "@field.yaml" {:link :Orange})
(vim.api.nvim_set_hl 0 :yamlBlockMappingKey {:link :Orange})
(vim.api.nvim_set_hl 0 :yamlPlainScalar {:link :String})
(vim.api.nvim_set_hl 0 :yamlBlockCollectionItemStart {:link :Gray})

(vim.api.nvim_set_hl 0 "@label.json" {:link :Orange})
(vim.api.nvim_set_hl 0 "@string.json" {:link :TSString})

(vim.api.nvim_set_hl 0 "@property.go" {:link :TSField})

(vim.api.nvim_set_hl 0 :GitSignsAdd {:link :GreenSign})
(vim.api.nvim_set_hl 0 :GitSignsChange {:link :OrangeSign})
(vim.api.nvim_set_hl 0 :GitSignsDelete {:link :RedSign})

(vim.api.nvim_set_hl 0 :MiniStarterHeader {:link :Green})
(vim.api.nvim_set_hl 0 :MiniStarterSection {:link :Red})
(vim.api.nvim_set_hl 0 :MiniStarterItem {:link :Gray})
(vim.api.nvim_set_hl 0 :MiniStarterItemBullet {:link :GreenBold})
(vim.api.nvim_set_hl 0 :MiniStarterItemPrefix {:link :GreenBold})
(vim.api.nvim_set_hl 0 :MiniStarterQuery {:link :Orange})
(vim.api.nvim_set_hl 0 :MiniStarterFooter {:link :Gray})

(vim.api.nvim_set_hl 0 :DevIconRb {:link :Red})

(vim.api.nvim_set_hl 0 :NvimTreeGitDirty {:link :Orange})
(vim.api.nvim_set_hl 0 :NvimTreeFolderIcon {:link :Yellow})

(vim.cmd "hi ErrorText gui=none")
(vim.cmd "hi WarningText gui=none")
(vim.cmd "hi HintText gui=none")
(vim.cmd "hi InfoText gui=none")
