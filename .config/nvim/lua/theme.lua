vim.o.background='dark'
vim.cmd [[
let g:everforest_background = 'hard'
let g:everforest_disable_italic_comment = 1

colorscheme everforest

hi Gray guifg=#a7b0a4

hi! link TSParameter Gray
hi! link TSOperator Gray
hi! link TSField TSVariable

hi! link rubyTSSymbol Orange
hi! link rubyTSLabel TSVariable
]]

