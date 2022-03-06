vim.o.background = "dark"

vim.g.everforest_background = "hard"
vim.g.everforest_disable_italic_comment = 1
vim.g.everforest_diagnostic_text_highlight = 1

vim.cmd([[
colorscheme everforest

hi Gray guifg=#a7b0a4
hi GreenBold guifg=#a7c080 gui=bold

hi! link TSParameter Gray
hi! link TSOperator Gray
hi! link TSField TSVariable

hi! link rubyTSSymbol Orange
hi! link rubyTSLabel TSVariable

hi! link yamlTSField Orange
hi! link yamlBlockMappingKey Orange
hi! link yamlPlainScalar String
hi! link yamlBlockCollectionItemStart Gray

hi! link GitSignsAdd GreenSign
hi! link GitSignsChange OrangeSign
hi! link GitSignsDelete RedSign

hi! link MiniStarterHeader Green
hi! link MiniStarterSection Red
hi! link MiniStarterItem Gray
hi! link MiniStarterItemBullet GreenBold
hi! link MiniStarterItemPrefix GreenBold
hi! link MiniStarterQuery Orange
hi! link MiniStarterFooter Gray

hi IndentBlanklineIndent1 guibg=NONE gui=nocombine
hi IndentBlanklineIndent2 guibg=#323c41 gui=nocombine

hi! link DevIconRb Red

hi! link NvimTreeGitDirty Orange
hi! link NvimTreeFolderIcon Yellow
]])
