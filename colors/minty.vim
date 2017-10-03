" Vim color scheme
" Created by Bryce Aidukaitis
" Friday, July 14th, 2017
" Based on the 'torte' color scheme, my favorite

hi clear
if exists("syntax_on")
    syntax reset
endif

"Optionally load 'base' color scheme
runtime /usr/share/vim/vim74/colors/torte.vim
"colo torte
" All changes will be made on top of this!

" Set color scheme name 
let g:colors_name = "minty"

" GUI
"highlight Normal     guifg=Grey80	guibg=Black
"highlight Search     guifg=Black	guibg=Red	gui=bold
"highlight Visual     guifg=#404040			gui=bold
"highlight Cursor     guifg=Black	guibg=Green	gui=bold
"highlight Special    guifg=Orange
"highlight Comment    guifg=#80a0ff
"highlight StatusLine guifg=blue		guibg=white
"highlight Statement  guifg=Yellow			gui=NONE
"highlight Type						gui=NONE

" Console
highlight Normal     ctermfg=LightGrey	ctermbg=Black
highlight Search     ctermfg=Black	    ctermbg=Red	    cterm=NONE
highlight Visual					                    cterm=reverse
highlight Cursor     ctermfg=Black	    ctermbg=Green	cterm=bold
highlight Special    ctermfg=Brown
highlight Comment    ctermfg=Blue
highlight StatusLine ctermfg=Blue	    ctermbg=white
highlight Statement  ctermfg=Yellow		                cterm=NONE
"highlight Statement  ctermfg=Yellow
highlight Type						                    cterm=NONE
highlight HelpUrl    ctermfg=magenta
highlight HelpString ctermfg=magenta

" only for vim 5
"if has("unix")
  "if v:version<600
    "highlight Normal  ctermfg=Grey	ctermbg=Black	cterm=NONE	guifg=Grey80      guibg=Black	gui=NONE
    "highlight Search  ctermfg=Black	ctermbg=Red	cterm=bold	guifg=Black       guibg=Red	gui=bold
    "highlight Visual  ctermfg=Black	ctermbg=yellow	cterm=bold	guifg=#404040			gui=bold
    "highlight Special ctermfg=LightBlue			cterm=NONE	guifg=LightBlue			gui=NONE
    "highlight Comment ctermfg=Cyan			cterm=NONE	guifg=LightBlue			gui=NONE
  "endif
"endif

"NOTE: To see what things go to, type the vim command ": sy list" in 
" Something of that file type (i.e., do it form a JavaScipt file to see
" what key words and such have what colors 

" ------------- JAVASCRIPT -------------------
" Custom Javascript syntax 
syn keyword javaScriptExtraSpecial console
"syn region  javaScriptClass start="{" end="}" contains=javaScriptExtraSpecial

" JavaScript-specific colors 
hi  javascriptStatement     ctermfg=LightBlue
hi  javascriptConditional   ctermfg=Magenta
hi  javascriptRepeat        ctermfg=Magenta 
hi  javascriptBranch        ctermfg=Magenta 
hi  javascriptException     ctermfg=Magenta
hi  javaScriptLabel         ctermfg=Magenta
hi  javascriptNull          ctermfg=Blue
hi  javaScriptIdentifier    ctermfg=DarkGreen
hi  javaScriptFunction      ctermfg=DarkGreen 
hi  javaScriptReserved      ctermfg=DarkGreen
hi  javascriptMember        ctermfg=DarkCyan
hi  javaScriptStringS       ctermfg=Magenta 
hi  javaScriptStringD       ctermfg=Magenta

" Custom syntax things 
hi javaScriptExtraSpecial   ctermfg=LightGreen
hi javaScriptClass          ctermfg=LightGreen

" For 256-color displays
if &t_Co>255
    hi  javaScriptLineComment   ctermfg=69
    hi  javascriptConditional   ctermfg=99
    hi  javascriptRepeat        ctermfg=99
    hi  javascriptBranch        ctermfg=99
    hi  javascriptException     ctermfg=99
    hi  javaScriptLabel         ctermfg=99
    hi  javaScriptIdentifier    ctermfg=21
    hi  javaScriptFunction      ctermfg=99
    hi  javaScriptReserved      ctermfg=99
    hi  javascriptStatement     ctermfg=99
    hi  javaScriptStringS       ctermfg=213
    hi  javaScriptStringD       ctermfg=213

    hi  javaScriptExtraSpecial  ctermfg=49
endif

func! GetColors()
    if &t_Co==256
        echo &t_Co
    else 
        echo &t_Co
    endif
endfunction
