set lines=999
set columns=999

set guicursor=n-v-c:block-Cursor/lCursor-blinkoff500-blinkon500,
			\ve:ver35-Cursor-blinkoff500-blinkon500,
			\o:hor50-Cursor-blinkoff500-blinkon500,
			\i-ci:ver25-Cursor/lCursor-blinkoff500-blinkon500,
			\r-cr:hor20-Cursor/lCursor-blinkoff500-blinkon500,
			\sm:block-Cursor-blinkwait10-blinkoff500-blinkon500

" GUI Font:

" bewaehrt
if has("win32")
    " set guifont=terminus:h12
    " set guifont=terminus:h16
    " set guifont=terminus:h24
    " set guifont=Fira_Mono:h10
    " set guifont=Fira_Mono:h12
    " set guifont=Fira_Mono:h14
    " set guifont=Fira_Mono:h18
    " set guifont=mononoki:h10
    " set guifont=mononoki:h12
    " set guifont=mononoki:h14
    " set guifont=mononoki:h18
    " set guifont=PT_Mono:h10
    set guifont=PT_Mono:h12
    " set guifont=PT_Mono:h14
    " set guifont=PT_Mono:h18
    " set guifont=IBM_3270:h12
    " set guifont=IBM_3270:h16
    " set guifont=IBM_3270:h24
    " set guifont=IBM_3270_Semi-Condensed:h24
    " set guifont=IBM_3270_Semi-Condensed:h24:cANSI:qDRAFT
    " set guifont=IBM_3270_Semi-Condensed:h24:b:cANSI:qDRAFT
else
    set guifont=Terminus\ 12
endif

" tests
" set guifont=Tamsyn10x20:h16:cANSI:qDRAFT " gut
" set guifont=Anonymous_Pro:h14 " ganz gut
" set guifont=Anonymous_Pro:h16 " ganz gut
" set guifont=Source_Code_Pro_ExtraLight:h14:W200:cANSI:qDRAFT " ganz gut 1 vs l kaum unterscheidbar wenn alleinstehend bzw sehr gewoehnungsbeduerftig
" set guifont=Source_Code_Pro:h14:cANSI:qDRAFT " 1 vs l nur etwas besser unterscheidbar wenn alleinstehend
" set guifont=Consolas:h14 " ganz ok
" set guifont=Fira_Code_Retina:h16:W450:cANSI:qDRAFT " ganz ok
" set guifont=HE_TERMINAL:h16:cANSI:qDRAFT " 0(null) und O (Oh) sind fast absolut gleich

" pixel fonts
" set guifont=Dina:h12:cANSI:qDRAFT " sehr cool aber etwas klein :)
" set guifont=Dina:h14:cANSI:qDRAFT " sehr cool aber sehr gross :)
" set guifont=ProggyOpti:h16:cANSI:qDRAFT " sehr cool aber gross :)
" set guifont=ProggyOpti:h9:cANSI:qDRAFT " cool aber sehr klein :(
" set guifont=Fixedsys:h18:cANSI:qDRAFT " cool aber sehr gross :)
" set guifont=Fixedsys:h9:cANSI:qDRAFT " cool aber sehr klein :(
" set guifont=Crisp:h18:cANSI:qDRAFT " geht so
" set guifont=Hack:h16:cANSI:qDRAFT " geht so

" testzeile: [](){}1|!|l!1lI71 2Z 5S 6b 08B0 pgq9 coO0Q 0DOCO ‰ˆ¸ƒ÷‹ '` ,. :; +-*/= `''"'""` <-> <=>
if 0
  let g:loeschmich="testzeile: ()[]{}1|!|l!1lI71 2Z 5S 6b 08B0 pgq9 coO0Q ODODCO ‰ˆ¸ƒ÷‹ '` ,. :; +-*/= `''\"'\"\"`" <-> <=>
endif
