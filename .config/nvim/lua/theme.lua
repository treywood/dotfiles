vim.o.background='dark'
vim.cmd [[
colorscheme material

hi Normal guibg=#292D3E
hi NormalNC guibg=#292D3E
hi LineNr guibg=NONE
hi SignColumn guibg=#292D3E
hi EndOfBuffer guibg=#292D3E
hi CursorLine guibg=#30354A
hi CursorLineNC guibg=#292D3E

augroup telescope
	autocmd!
	au User TelescopeFindPre hi TelescopeBorder guibg=#292D3E
	au User TelescopeFindPre hi TelescopePreviewBorder guibg=#292D3E
	au User TelescopeFindPre hi TelescopePromptBorder guibg=#292D3E
	au User TelescopeFindPre hi TelescopeResultsBorder guibg=#292D3E

	au User TelescopeFindPre hi TelescopeNormal guibg=#292D3E
	au User TelescopeFindPre hi TelescopePreviewNormal guibg=#292D3E
	au User TelescopeFindPre hi TelescopePromptNormal guibg=#292D3E
	au User TelescopeFindPre hi TelescopeResultsNormal guibg=#292D3E

	au User TelescopeFindPre hi TelescopeSelection guibg=#30354A guifg=White
	au User TelescopeFindPre hi TelescopeSelectionCaret guibg=#30354A guifg=White
augroup END

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

