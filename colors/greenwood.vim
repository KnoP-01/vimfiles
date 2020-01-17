" Vim color file
" Maintainer:  Mz
" Version:     1.0
" Last Change: 13-12-2019 15:38

set bg=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "greenwood"

hi Normal         guifg=White       guibg=#005050     gui=none       ctermfg=White        ctermbg=Black
hi ErrorMsg       guifg=Yellow      guibg=#005050     gui=none       ctermfg=White        ctermbg=Lightblue
hi Visual         guifg=White       guibg=LightRed    gui=none       ctermfg=Lightblue    ctermbg=fg              cterm=reverse
hi VisualNOS      guifg=White       guibg=#005050     gui=underline  ctermfg=Lightblue    ctermbg=fg              cterm=reverse,underline
hi Todo           guifg=Cyan        guibg=#005050     gui=none       ctermfg=Yellow       ctermbg=Darkblue
hi Search         guifg=Yellow      guibg=#005050     gui=none       ctermfg=White        ctermbg=Darkblue        cterm=underline         term=underline
hi IncSearch      guifg=Red         guibg=Grey        gui=none       ctermfg=Darkblue     ctermbg=Gray
hi Number         guifg=White       guibg=#005050     gui=none       ctermfg=White        ctermbg=Black

hi ColorColumn                      guibg=#006050   gui=none
hi CursorLine     guifg=White       guibg=#006050   gui=none       ctermfg=Black        ctermbg=White

hi SpecialKey     guifg=Cyan        guibg=#005050     gui=none       ctermfg=Darkcyan
hi Directory      guifg=Cyan        guibg=#005050     gui=none       ctermfg=Cyan
hi Title          guifg=Magenta     guibg=#005050     gui=none       ctermfg=Magenta                              cterm=bold
hi WarningMsg     guifg=Yellow      guibg=#005050     gui=none       ctermfg=Yellow
hi WildMenu       guifg=Yellow      guibg=#005050     gui=none       ctermfg=Yellow       ctermbg=Black           cterm=none              term=none
hi ModeMsg        guifg=Yellow                        gui=none       ctermfg=Lightblue
hi MoreMsg                                                           ctermfg=Darkgreen    ctermfg=Darkgreen
hi Question       guifg=Yellow      guibg=#005050     gui=none       ctermfg=Green                                cterm=none
hi NonText        guifg=Yellow      guibg=#005050     gui=none       ctermfg=Darkblue

hi StatusLine     guifg=Blue        guibg=Grey        gui=none       ctermfg=Blue         ctermbg=Gray            cterm=none              term=none
hi StatusLineNC   guifg=Blue        guibg=Grey        gui=none       ctermfg=Black        ctermbg=Gray            cterm=none              term=none
hi VertSplit      guifg=Blue        guibg=Gray        gui=none       ctermfg=Black        ctermbg=Gray            cterm=none              term=none

hi Folded         guifg=Yellow      guibg=#005050     gui=none       ctermfg=Darkgrey     ctermbg=Black           cterm=bold              term=bold
hi FoldColumn     guifg=Yellow      guibg=#005050     gui=none       ctermfg=Darkgrey     ctermbg=Black           cterm=bold              term=bold
hi LineNr         guifg=Lightred    guibg=#005050     gui=none       ctermfg=Green                                cterm=none

hi DiffAdd        guibg=Yellow      guibg=#005050     gui=none       ctermbg=Darkblue     cterm=none              term=none
hi DiffChange     guibg=Yellow      guibg=LightMagenta gui=none       ctermbg=LightRed     cterm=none
hi DiffDelete     guifg=Yellow      guibg=#005050     gui=none       ctermfg=Blue         ctermbg=Cyan
hi DiffText       guifg=White       guibg=Red         gui=bold                            ctermbg=Yellow          cterm=bold

hi Cursor         guifg=Yellow      guibg=Yellow      gui=none       ctermfg=Black        ctermbg=Yellow
hi lCursor        guifg=Yellow      guibg=Yellow      gui=none       ctermfg=Black        ctermbg=White

hi SpellBad       guifg=White       guibg=#005050     gui=underline  ctermfg=015          ctermbg=000             cterm=none
hi SpellCap       guifg=White       guibg=#005050     gui=underline  ctermfg=015          ctermbg=000             cterm=none
hi SpellLocal     guifg=White       guibg=#005050     gui=underline  ctermfg=015          ctermbg=000             cterm=none
hi SpellRare      guifg=White       guibg=#005050     gui=underline  ctermfg=015          ctermbg=000             cterm=none

hi Comment        guifg=Gray        guibg=#005050     gui=none       ctermfg=White
hi Constant       guifg=Cyan        guibg=#005050     gui=none       ctermfg=Magenta                              cterm=none
hi Special        guifg=Orange      guibg=#005050     gui=none       ctermfg=Brown                                cterm=none
hi Identifier     guifg=Orange      guibg=#005050     gui=none       ctermfg=Cyan                                 cterm=none
hi Statement      guifg=Orange      guibg=#005050     gui=none       ctermfg=Yellow                               cterm=none
hi PreProc        guifg=Orange      guibg=#005050     gui=none       ctermfg=Magenta                              cterm=none
hi Type           guifg=Orange      guibg=#005050     gui=none       ctermfg=Green                                cterm=none
hi Underlined                                         gui=none                                                    cterm=underline         term=underline
hi Ignore         guifg=bg          guibg=#005050     gui=none       ctermfg=bg

hi Pmenu          guifg=#c0c0c0     guibg=#404080     gui=none
hi PmenuSel       guifg=#c0c0c0     guibg=#2050d0     gui=none
hi PmenuSbar      guifg=blue        guibg=darkgray    gui=none
hi PmenuThumb     guifg=#c0c0c0     guibg=#005050     gui=none

" EOF
