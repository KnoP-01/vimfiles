set lines=56
set columns=189

set guicursor=n-v-c:block-Cursor/lCursor-blinkoff500-blinkon500,
			\ve:ver35-Cursor-blinkoff500-blinkon500,
			\o:hor50-Cursor-blinkoff500-blinkon500,
			\i-ci:ver25-Cursor/lCursor-blinkoff500-blinkon500,
			\r-cr:hor20-Cursor/lCursor-blinkoff500-blinkon500,
			\sm:block-Cursor-blinkwait10-blinkoff500-blinkon500

" GUI Font:

" bewaehrt
if has("win32")
    set guifont=terminus:h14
else
    set guifont=Terminus\ 14
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

" testzeile: ()[]{}1||l!1lI71 2Z 5S 6b 08B0 pgq oO0Q ODODCO ‰ˆ¸ƒ÷‹ '` ,. :; +-*/= `''"'""` <-> <=>
if 0
	let g:loeschmich="testzeile: ()[]{}1|!|l!1lI71 2Z 5S 6b 08B0 pgq oO0Q ODODCO ‰ˆ¸ƒ÷‹ '` ,. :; +-*/= `''\"'\"\"`" <-> <=>
endif
