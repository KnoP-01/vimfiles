" Staubli pgx file type plugin for Vim
" Language: staubli
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 15. Nov 2024
"

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:keepcpo = &cpo
set cpo&vim

setlocal comments=://
setlocal commentstring=//%s
setlocal suffixesadd+=.pgx,.pjx
let b:undo_ftplugin = "setlocal com< cms< sua<"

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et fdm=marker
