vim.o.background='dark'
vim.cmd [[
colorscheme material

hi Normal guibg=#292D3E ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=#292D3E ctermbg=NONE
hi EndOfBuffer guibg=#292D3E ctermbg=NONE

hi TSType guifg=#ffcb6b
hi TSKeyword guifg=#C792EA
hi TSKeywordReturn guifg=#C792EA
hi TSVariable guifg=White
hi TSVariableBuiltin guifg=#C792EA
hi TSParameter guifg=#A6ACCD
hi TSInclude guifg=#C792EA
hi TSProperty guifg=White
hi TSOperator guifg=White
hi TSTagAttribute guifg=White
hi TSStringRegex guifg=#C3E88D
hi TSOperator guifg=#a6accd

hi rubyTSSymbol guifg=#f5a790
hi rubyTSLabel guifg=White
hi rubyTSException guifg=#C792EA

hi javascriptTSConstructor guifg=#ffcb6b 

hi haskellTSConstructor guifg=#ffcb6b
]]

