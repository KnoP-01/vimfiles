" ABB Safety XML
" Language: XML
" Maintainer: Patrick Knosowski <knosowski@graeff.de>
" Version: 0.0.1
" Last Change: 2016 Oct 31
" Credits:
"

let s:keepcpo= &cpo
set cpo&vim

au! filetypedetect BufNewFile,BufRead *.sxml setf xml

let &cpo = s:keepcpo
unlet s:keepcpo

