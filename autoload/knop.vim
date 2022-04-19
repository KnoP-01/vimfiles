" Vim autoload file
" Language: Helper functions used for Kuka Robot Language, ABB RAPID and maybe others
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 3.0.0
" Last Change: 19. Apr 2022

" Init {{{
if exists("g:loaded_knop")
  finish
endif
let g:loaded_knop = 1

let s:keepcpo = &cpo
set cpo&vim
" }}} Init 

function knop#NTimesSearch(nCount, sSearchPattern, sFlags) abort
  let l:nCount = a:nCount
  let l:sFlags = a:sFlags
  while l:nCount > 0
    if l:nCount < a:nCount
      let l:sFlags = substitute(l:sFlags, 's', '', 'g')
    endif
    call search(a:sSearchPattern, l:sFlags)
    let l:nCount -= 1
  endwhile
endfunction

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
