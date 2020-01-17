" Vim color file
" Maintainer:   Patrick Meiser-Knosowski (aka KnoP)
" Last Change:  10. Jan 2020
" tries to look like abb robot studio

set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = "robotstudio"

" GUI
highlight Normal       guifg=black
highlight Search       guifg=Black      guibg=Orange
highlight Delimiter    guifg=black
highlight Operator     guifg=black
highlight Visual       gui=reverse
highlight Cursor       guibg=Black
highlight Comment      guifg=#008000
highlight Statement    guifg=#0000ff    gui=NONE
highlight Type         guifg=#0000ff    gui=NONE
highlight RapidType    guifg=#1e6e91
highlight KrlType      guifg=#1e6e91
highlight Function     guifg=#1e6e91
highlight PreProc      guifg=magenta
highlight Constant     guifg=black
highlight RapidString  guifg=#800000
highlight KrlString    guifg=#800000
highlight Folded       guifg=#800000
highlight StatusLineNC guifg=#505050    guibg=#cccccc



