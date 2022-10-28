" ABB Rapid Command file type detection for Vim
" Language: ABB Rapid Command
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Last Change: 05. Sep 2022
"

let s:keepcpo = &cpo
set cpo&vim

au! BufNewFile,BufRead *.modx,*.Modx,*.MODX,*.modx\c
      \  setf rapid

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et
