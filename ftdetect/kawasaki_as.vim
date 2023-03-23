" Vim file type detection file
" Language: Kawasaki AS-language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 23. Mar 2023
"

let s:keepcpo = &cpo
set cpo&vim

" no augroup! see :h ftdetect
au!  BufNewFile,BufRead *.as,*.pg setf kawasaki_as

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et
