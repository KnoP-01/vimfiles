" Vim file type detection file
" Language: staubli
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 15. Nov 2024
" Credits:
"

let s:keepcpo = &cpo
set cpo&vim

" no augroup! see :h ftdetect
au!  BufNewFile,BufRead *.pjx setf staubli
" au!  BufRead    *.pjx setf staubli
" au!  BufNewFile *.pgx setf staubli
" au!  BufRead    *.pgx setf staubli 

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et
