" Vim file type detection file
" Language: Kuka Robot Language UserTech fold file
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 07. Feb 2024
" Credits:
"

let s:keepcpo = &cpo
set cpo&vim

au!  BufNewFile,BufRead *.kfd\c
      \  setf krl

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et
