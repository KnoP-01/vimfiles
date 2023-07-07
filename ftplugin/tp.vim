" Fanuc TP file type plugin for Vim
" Language: Fanuc TP
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 03. Jul 2023
"
" Suggestions of improvement are very welcome. Please email me!
"
" ToDo's {{{
" }}} ToDo's

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:keepcpo = &cpo
set cpo&vim

setlocal suffixesadd+=.ls
setlocal suffixesadd+=.LS
setlocal suffixesadd+=.pe
setlocal suffixesadd+=.PE

nnoremap <silent><buffer> <leader>dc :%s/\(LBL\)\@<![\[,]\d\+\zs:[^\]]*//g<CR>
let b:undo_ftplugin = "setlocal sua<"

let b:match_ignorecase = 1
let b:match_words = '\<IF\>.*:\<ELSE\>.*:\<ENDIF\>.*,'
      \.'\<FOR\>.*:\<ENDFOR\>.*,'
      \.'\<LBL\[\(\d\+\)\>.*:\<JMP LBL\[\1\>.*,'
      \.'\<JMP LBL\[\(\d\+\)\>.*:\<LBL\[\1\>.*'
      " \.'\%(\<JMP\s\+\)\?\<LBL\[\(\d\+\).*:\<LBL\[\1.*:\<LBL\[\1.*,'
      " \.'\<LBL\[\(\d\+\).*:\<LBL\[\1.*:\%(\<JMP\s\+\)\?\<LBL\[\1.*,'
      " \.'\<LBL\[\(\d\+\).*:\%(\<JMP\s\+\)\?\<LBL\[\1.*:\<LBL\[\1.*'

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et fdm=marker
