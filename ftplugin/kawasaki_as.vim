" Vim file type plugin
" Language: Kawasaki AS-language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 21. Mar 2023
"

" Init {{{

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:keepcpo = &cpo
set cpo&vim

" }}} init

" Vim Settings {{{

" default on; no option
setlocal commentstring=;%s
setlocal comments=:\;
let b:undo_ftplugin = "setlocal com< cms<"

" auto insert comment char when i_<CR>, o or O on a comment line
if get(g:,'asAutoComment',1)
  setlocal formatoptions+=r
  setlocal formatoptions+=o
  let b:undo_ftplugin = b:undo_ftplugin." fo<"
endif

" format comments
if get(g:,'asFormatComments',1)
  if &textwidth ==# 0
    " 78 Chars 
    setlocal textwidth=78
    let b:undo_ftplugin = b:undo_ftplugin." tw<"
  endif
  setlocal formatoptions-=t
  setlocal formatoptions+=l
  setlocal formatoptions+=j
  if stridx(b:undo_ftplugin, " fo<")==(-1)
    let b:undo_ftplugin = b:undo_ftplugin." fo<"
  endif
endif " format comments

" }}} Vim Settings

" Move Around and Function Text Object key mappings {{{

if get(g:,'asMoveAroundKeyMap',1)
  nnoremap <silent><buffer> ]] :<C-U>                     call search('^\.'              ,   'sw')<cr>
  onoremap <silent><buffer> ]] :<C-U>exe "normal! v" <Bar>call search('\(\ze\n\.\\|\%$\)',   'eW')<cr>
  xnoremap <silent><buffer> ]] :<C-U>exe "normal! gv"<Bar>call search('\(^\.\\|\%$\)'    ,   'sW')<cr>
  nnoremap <silent><buffer> [[ :<C-U>                     call search('^\.'              ,   'bsw')<cr>
  onoremap <silent><buffer> [[ :<C-U>                     call search('^\.'              ,   'bW')<cr>
  xnoremap <silent><buffer> [[ :<C-U>exe "normal! gv"<Bar>call search('^\.'              ,   'bsW')<cr>
  nnoremap <silent><buffer> ][ :<C-U>                     call search('.*\(\n\.\\|\%$\)' ,   'sw')<cr>
  onoremap <silent><buffer> ][ :<C-U>exe "normal! v" <Bar>call search('\(\n\.\\|\%$\)'   ,   'sW')<cr>
  xnoremap <silent><buffer> ][ :<C-U>exe "normal! gv"<Bar>call search('\(\n\.\\|\%$\)'   ,   'sW')<cr>
  nnoremap <silent><buffer> [] :<C-U>                     call search('^\.\n\w\+:\n\n'   ,   'besw')<cr>
  onoremap <silent><buffer> [] :<C-U>exe "normal! V" <Bar>call search('^\.\n\w\+:\n\n'   ,   'besW')<cr>
  xnoremap <silent><buffer> [] :<C-U>exe "normal! gv"<Bar>call search('^\.\n\w\+:\n\n'   ,   'besW')<cr>
endif

" }}} Move Around and Function Text Object key mappings

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
