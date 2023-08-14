" Vim file type plugin
" Language: Kawasaki AS-language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.1
" Last Change: 14. Aug 2023
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

  function! <SID>KnopNTimesSearch(nCount,sSearchPattern,sFlags) abort
    let l:nCount=a:nCount
    let l:sFlags=a:sFlags
    while l:nCount>0
      if l:nCount < a:nCount
        let l:sFlags=substitute(l:sFlags,'s','','g')
      endif
      call search(a:sSearchPattern,l:sFlags)
      let l:nCount-=1
    endwhile
  endfunction " <SID>KnopNTimesSearch()

  " Move around functions
  nnoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v^\.(END)@!\u'       , 'sw')<cr>
  nnoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v^\.(END)@!\u'       , 'bsw')<cr>
  nnoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c^\.END\>'           , 'sw')<cr>
  nnoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c^\.END\>'           , 'bsw')<cr>

  onoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1<Bar>exe "normal!  V"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v^\.(END)@!\u.*\n'   , 'seWz')<cr>
  onoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1<Bar>exe "normal!  V"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v\n\.(END)@!\u.*\n'  , 'sebW')<cr>
  onoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1<Bar>exe "normal!  V"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v^\.END.*\n'       , 'seWz')<cr>
  onoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1<Bar>exe "normal!  V"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v\n\.END.*\n'      , 'sebW')<cr>

  xnoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v^\.(END)@!\u.*\n'   , 'seWz')<cr>
  xnoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v\n\.(END)@!\u.*\n'  , 'sebW')<cr>
  xnoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v^\.END.*\n'       , 'seWz')<cr>
  xnoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch( b:knopCount , '\c\v\n\.END.*\n'      , 'sebW')<cr>

  " Move around comments
  nnoremap <silent><buffer> [; :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v(^\s*;.*\n)@<!(^\s*;)'       , 'bs'  )<Bar>unlet b:knopCount<cr>
  nnoremap <silent><buffer> ]; :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^\s*;.*\n\s*([^;\t ]\|$)'    , 's'   )<Bar>unlet b:knopCount<cr>

  onoremap <silent><buffer> [; :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v(^\s*;.*\n)@<!(^\s*;)'       , 'bsW' )<Bar>unlet b:knopCount<cr>
  onoremap <silent><buffer> ]; :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^\s*;.*\n(\s*[^;\t ]\|$)'    , 'seW' )<Bar>unlet b:knopCount<cr>

  xnoremap <silent><buffer> [; :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v(^\s*;.*\n)@<!(^\s*;)'       , 'bsW' )<Bar>unlet b:knopCount<cr>
  xnoremap <silent><buffer> ]; :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^\s*;.*\n\ze\s*([^;\t ]\|$)' , 'seW' )<Bar>unlet b:knopCount<cr>

  function! <SID>AsFunctionTextObject(inner) abort
    if a:inner==1
      let l:n = 1
    else
      let l:n = v:count1
    endif
    if getline('.')!~'\c\v^\.END>'
      silent normal ][
    endif
    silent normal [[
    silent normal! zz
    if a:inner==1
      silent normal! j
    endif
    exec "silent normal V".l:n."]["
    if a:inner==1
      silent normal! k
    endif
  endfunction " AsFunctionTextObject()

  function! <SID>AsCommentTextObject(around) abort
    if getline('.')!~'^\s*;' && !search('^\s*;',"sW")
      return
    endif
    " starte innerhalb des oder nach dem kommentar
    silent normal! j
    silent normal [;
    if getline(line('.')+1)!~'^\s*;'
      silent normal! V
    else
      silent normal! V
      silent normal ];
    endif
    if a:around && getline(line('.')+1)=~'^\s*$'
      silent normal! j
    endif
  endfunction " AsCommentTextObject()

  " inner and around function text objects
  if get(g:,'asFunctionTextObject',0)
        \|| mapcheck("af","x")=="" && !hasmapto('<plug>AsTxtObjAroundFunc','x')
    xmap <silent><buffer> af <plug>AsTxtObjAroundFunc
  endif
  if get(g:,'asFunctionTextObject',0)
        \|| mapcheck("if","x")=="" && !hasmapto('<plug>AsTxtObjInnerFunc','x')
    xmap <silent><buffer> if <plug>AsTxtObjInnerFunc
  endif
  if get(g:,'asFunctionTextObject',0)
        \|| mapcheck("af","o")=="" && !hasmapto('<plug>AsTxtObjAroundFunc','o')
    omap <silent><buffer> af <plug>AsTxtObjAroundFunc
  endif
  if get(g:,'asFunctionTextObject',0)
        \|| mapcheck("if","o")=="" && !hasmapto('<plug>AsTxtObjInnerFunc','o')
    omap <silent><buffer> if <plug>AsTxtObjInnerFunc
  endif
  " inner and around comment text objects
  if get(g:,'asCommentTextObject',0)
        \|| mapcheck("ac","x")=="" && !hasmapto('<plug>AsTxtObjAroundComment','x')
    xmap <silent><buffer> ac <plug>AsTxtObjAroundComment
  endif
  if get(g:,'asCommentTextObject',0)
        \|| mapcheck("ic","x")=="" && !hasmapto('<plug>AsTxtObjInnerComment','x')
    xmap <silent><buffer> ic <plug>AsTxtObjInnerComment
  endif
  if get(g:,'asCommentTextObject',0)
        \|| mapcheck("ac","o")=="" && !hasmapto('<plug>AsTxtObjAroundComment','o')
    omap <silent><buffer> ac <plug>AsTxtObjAroundComment
  endif
  if get(g:,'asCommentTextObject',0)
        \|| mapcheck("ic","o")=="" && !hasmapto('<plug>AsTxtObjInnerComment','o')
    omap <silent><buffer> ic <plug>AsTxtObjInnerComment
  endif

  xnoremap <silent><buffer> <plug>AsTxtObjAroundFunc     :<C-U>call <SID>AsFunctionTextObject(0)<CR>
  xnoremap <silent><buffer> <plug>AsTxtObjInnerFunc      :<C-U>call <SID>AsFunctionTextObject(1)<CR>

  onoremap <silent><buffer> <plug>AsTxtObjAroundFunc     :<C-U>call <SID>AsFunctionTextObject(0)<CR>
  onoremap <silent><buffer> <plug>AsTxtObjInnerFunc      :<C-U>call <SID>AsFunctionTextObject(1)<CR>

  xnoremap <silent><buffer> <plug>AsTxtObjAroundComment  :<C-U>call <SID>AsCommentTextObject(1)<CR>
  xnoremap <silent><buffer> <plug>AsTxtObjInnerComment   :<C-U>call <SID>AsCommentTextObject(0)<CR>

  onoremap <silent><buffer> <plug>AsTxtObjAroundComment  :<C-U>call <SID>AsCommentTextObject(1)<CR>
  onoremap <silent><buffer> <plug>AsTxtObjInnerComment   :<C-U>call <SID>AsCommentTextObject(0)<CR>

endif

" }}} Move Around and Function Text Object key mappings

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
