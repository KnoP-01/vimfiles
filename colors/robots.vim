set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = "robots"

 

" GUI
highlight Normal     guifg=black
highlight Search     guifg=Black    guibg=Orange     gui=bold
highlight Delimiter  guifg=black
highlight Operator   guifg=black
highlight Visual     guifg=#404040    gui=bold
highlight Cursor     guifg=Black    guibg=Green
highlight Number     guifg=red
highlight Comment    guifg=#004d00

 

highlight Statement  guifg=#0000ff  gui=NONE
highlight Type       guifg=#0000ff  gui=NONE

 

highlight String     guifg=#800000
highlight LineNr     guifg=#808080
highlight StatusLine guifg=white    guibg=#4d4d4d     gui=NONE
highlight Folded     guifg=brown    guibg=white

 

highlight RapidType  guifg=#1e6e91
highlight Function   guifg=#1e6e91
highlight PreProc    guifg=magenta
highlight Constant   guifg=black
highlight RapidString  guifg=#800000
