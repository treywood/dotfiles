vim.o.background='dark'
vim.cmd [[
let g:everforest_background = 'hard'
let g:everforest_disable_italic_comment = 1
let g:everforest_diagnostic_text_highlight = 1

colorscheme everforest

hi Gray guifg=#a7b0a4
hi GreenBold guifg=#a7c080 gui=bold

hi! link TSParameter Gray
hi! link TSOperator Gray
hi! link TSField TSVariable

hi! link rubyTSSymbol Orange
hi! link rubyTSLabel TSVariable

hi! link GitSignsAdd Green
hi! link GitSignsChange Orange
hi! link GitSignsDelete Red

hi! link MiniStarterHeader Green
hi! link MiniStarterSection Red
hi! link MiniStarterItem Fg
hi! link MiniStarterItemBullet GreenBold
hi! link MiniStarterItemPrefix GreenBold
hi! link MiniStarterQuery Orange
hi! link MiniStarterFooter Gray

hi IndentBlanklineIndent1 guibg=NONE gui=nocombine
hi IndentBlanklineIndent2 guibg=#323c41 gui=nocombine
]]

