" Vim file type plugin
" Language: Kuka Robot Language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 3.0.0
" Last Change: 12. May 2023
"
" ToDo's {{{
" }}} ToDo's

" Init {{{
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:keepcpo = &cpo
set cpo&vim
" }}} init

" Vim Settings {{{

setlocal commentstring=;%s
setlocal comments=:;

if has("fname_case")
  setlocal suffixes+=.dat,.Dat,.DAT
  setlocal suffixesadd+=.src,.Src,.SRC,.sub,.Sub,.SUB,.dat,.Dat,.DAT
else
  setlocal suffixes+=.dat
  setlocal suffixesadd+=.src,.sub,.dat
endif
let b:undo_ftplugin = "setlocal commentstring< comments< suffixes< suffixesadd<"

" make header items, enums and sysvars a word including the characters #,$ and & 
if get(g:,'krlKeyWord',1)
  setlocal iskeyword+=&,$,#
  let b:undo_ftplugin .= " iskeyword<"
endif

" auto insert comment char when i_<CR>, o or O on a comment line
if get(g:,'krlAutoComment',1)
  setlocal formatoptions+=r
  setlocal formatoptions+=o
  let b:undo_ftplugin .= " formatoptions<"
endif

" format comments
if get(g:,'krlFormatComments',1)
  if &textwidth == 0
    " 54 Chars do match on the teach pendant
    setlocal textwidth=54
    let b:undo_ftplugin .= " textwidth<"
  endif
  setlocal formatoptions-=t
  setlocal formatoptions+=l
  setlocal formatoptions+=j
  if stridx(b:undo_ftplugin, " formatoptions<")==(-1)
    " formatoptions may have already been added earlier
    let b:undo_ftplugin .= " formatoptions<"
  endif
endif " format comments

" concealing
if has("conceal") && get(g:,'krlConcealFoldTail',1)
  if &conceallevel==0
    setlocal conceallevel=1
    let b:undo_ftplugin .= " conceallevel<"
  endif
endif

" folding
if has("folding")
  let s:krlFoldLevel = get(g:, 'krlFoldLevel', 1)
  setlocal foldmethod=expr
  setlocal foldtext=krl#FoldText()
  setlocal foldenable
  setlocal fillchars-=fold:-
  execute 'setlocal foldexpr=krl#FoldExpr(v:lnum,' . s:krlFoldLevel . ')'
  let b:undo_ftplugin .= " foldmethod< foldtext< foldenable< fillchars< foldexpr<"
endif

" }}} Vim Settings

" Endwise support (tpope) {{{
if exists("loaded_endwise")
  let b:endwise_addition  = '\=submatch(0)=~#"DEF\\>" ? "END" '
  let b:endwise_addition .= ': submatch(0)=~#"CASE" ? "ENDSWITCH" '
  let b:endwise_addition .= ': submatch(0)=~#"DEFAULT" ? "ENDSWITCH" '
  let b:endwise_addition .= ': submatch(0)=~#"REPEAT" ? "UNTIL <condition>" '
  let b:endwise_addition .= ': submatch(0)=~?"def\\>" ? "end" '
  let b:endwise_addition .= ': submatch(0)=~?"case" ? "endswitch" '
  let b:endwise_addition .= ': submatch(0)=~?"default" ? "endswitch" '
  let b:endwise_addition .= ': submatch(0)=~?"repeat" ? "until <condition>" '
  let b:endwise_addition .= ': submatch(0)=~#"\\u" ? "END" . toupper(submatch(0)) '
  let b:endwise_addition .= ': "end" . tolower(submatch(0))'
  let b:endwise_words     = 'def,deffct,defdat,then,loop,while,for,repeat,case,default'
  let b:endwise_pattern   = '^\s*\(\(global\s\+\)\?\zsdef\|\(global\s\+\)\?def\zs\(dat\|fct\)\|\zsif\|\zsloop\|\zswhile\|\zsfor\|\zscase\|\zsdefault\|\zsrepeat\)\>\ze'
  let b:endwise_syngroups = 'krlConditional,krlTypedef,krlRepeat'
endif
" }}} Endwise

" Match It and Fold Text Object mapping {{{

" matchit support
if exists("loaded_matchit") " depends on matchit (or matchup)
  let b:match_ignorecase = 1 " KRL does ignore case
  let b:match_words = '^\s*\<if\>.*:^\s*\<else\>.*:^\s*\<endif\>.*,'
        \.'^\s*\<\%(for\|while\|loop\|repeat\)\>.*:^\s*\<exit\>.*:^\s*\<\%(end\%(for\|while\|loop\)\|until\)\>.*,'
        \.'^\s*\<switch\>.*:^\s*\<case\>.*:^\s*\<default\>.*:^\s*\<endswitch\>.*,'
        \.'^\s*\%(global\s\+\)\?\<def\%(fct\)\?\>.*:^\s*\<resume\>.*:^\s*\<return\>.*:^\s*\<end\%(fct\)\?\>.*,'
        \.'^\s*\<defdat\>.*:^\s*\<enddat\>.*,'
        \.'^\s*\<\%(ptp_\)\?spline\>.*:^\s*\<endspline\>.*,'
        \.'^\s*\<skip\>.*:^\s*\<endskip\>.*,'
        \.'^\s*\<time_block\s\+start\>.*:^\s*\<time_block\s\+part\>.*:^\s*\<time_block\s\+end\>.*,'
        \.'^\s*\<const_vel\s\+start\>.*:^\s*\<const_vel\s\+end\>.*,'
        \.'^\s*;\s*\<fold\>.*:^\s*;\s*\<endfold\>.*'
  " matchit makes fold text objects easy
  if get(g:,'krlFoldTextObject',0)
        \|| mapcheck("ao","x")=="" && !hasmapto('<plug>KrlTxtObjAroundFold','x')
    xmap <silent><buffer> ao <plug>KrlTxtObjAroundFold
  endif
  if get(g:,'krlFoldTextObject',0)
        \|| mapcheck("io","x")=="" && !hasmapto('<plug>KrlTxtObjInnerFold','x')
    xmap <silent><buffer> io <plug>KrlTxtObjInnerFold
  endif
  if get(g:,'krlFoldTextObject',0)
        \|| mapcheck("ao","o")=="" && !hasmapto('<plug>KrlTxtObjAroundFold','o')
    omap <silent><buffer> ao <plug>KrlTxtObjAroundFold
  endif
  if get(g:,'krlFoldTextObject',0)
        \|| mapcheck("io","o")=="" && !hasmapto('<plug>KrlTxtObjInnerFold','o')
    omap <silent><buffer> io <plug>KrlTxtObjInnerFold
  endif
endif

" }}} Match It and Fold Text Object mapping

" Move Around and Function Text Object key mappings {{{

if get(g:,'krlMoveAroundKeyMap',1)
  " Move around functions
  nnoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*(global\s+)?def(fct\|dat)?>'         , 'bs'  )<Bar>unlet b:knopCount<CR>:normal! zt<CR>
  onoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*(global\s+)?def(fct\|dat)?>.*\n\zs'  , 'bsW' )<Bar>unlet b:knopCount<CR>
  xnoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*(global\s+)?def(fct\|dat)?>'         , 'bsW' )<Bar>unlet b:knopCount<CR>
  nnoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*(global\s+)?def(fct\|dat)?>'         , 's'   )<Bar>unlet b:knopCount<CR>:normal! zt<CR>
  onoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*(global\s+)?def(fct\|dat)?>'         , 'sW'  )<Bar>unlet b:knopCount<CR>
  xnoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*(global\s+)?def(fct\|dat)?>.*\n'     , 'seWz')<Bar>unlet b:knopCount<CR>
  nnoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*end(fct\|dat)?>'                     , 'bs'  )<Bar>unlet b:knopCount<CR>:normal! zb<CR>
  onoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*end(fct\|dat)?>\n^(.\|\n)'           , 'bseW')<Bar>unlet b:knopCount<CR>
  xnoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*end(fct\|dat)?>'                     , 'bsW' )<Bar>unlet b:knopCount<CR>
  nnoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*end(fct\|dat)?>'                     , 's'   )<Bar>unlet b:knopCount<CR>:normal! zb<CR>
  onoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\c\v\ze^\s*end(fct\|dat)?>'                  , 'sW'  )<Bar>unlet b:knopCount<CR>
  xnoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call knop#NTimesSearch(b:knopCount, '\c\v^\s*end(fct\|dat)?>(\n)?'                , 'seWz')<Bar>unlet b:knopCount<CR>
  " Move around comments
  nnoremap <silent><buffer> [; :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\v(^\s*;.*\n)@<!(^\s*;)'                     , 'bs'  )<Bar>unlet b:knopCount<cr>
  onoremap <silent><buffer> [; :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\v(^\s*;.*\n)@<!(^\s*;)'                     , 'bsW' )<Bar>unlet b:knopCount<cr>
  xnoremap <silent><buffer> [; :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call knop#NTimesSearch(b:knopCount, '\v(^\s*;.*\n)@<!(^\s*;)'                     , 'bsW' )<Bar>unlet b:knopCount<cr>
  nnoremap <silent><buffer> ]; :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\v^\s*;.*\n\s*([^;\t ]\|$)'                  , 's'   )<Bar>unlet b:knopCount<cr>
  onoremap <silent><buffer> ]; :<C-U>let b:knopCount=v:count1                     <Bar>call knop#NTimesSearch(b:knopCount, '\v^\s*;.*\n(\s*[^;\t ]\|$)'                  , 'seW' )<Bar>unlet b:knopCount<cr>
  xnoremap <silent><buffer> ]; :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call knop#NTimesSearch(b:knopCount, '\v^\s*;.*\n\ze\s*([^;\t ]\|$)'               , 'seW' )<Bar>unlet b:knopCount<cr>
  " inner and around function text objects
  if get(g:,'krlFunctionTextObject',0)
        \|| mapcheck("aF","x")=="" && !hasmapto('<plug>KrlTxtObjAroundFuncInclCo','x')
    xmap <silent><buffer> aF <plug>KrlTxtObjAroundFuncInclCo
  endif
  if get(g:,'krlFunctionTextObject',0)
        \|| mapcheck("af","x")=="" && !hasmapto('<plug>KrlTxtObjAroundFuncExclCo','x')
    xmap <silent><buffer> af <plug>KrlTxtObjAroundFuncExclCo
  endif
  if get(g:,'krlFunctionTextObject',0)
        \|| mapcheck("if","x")=="" && !hasmapto('<plug>KrlTxtObjInnerFunc','x')
    xmap <silent><buffer> if <plug>KrlTxtObjInnerFunc
  endif
  if get(g:,'krlFunctionTextObject',0)
        \|| mapcheck("aF","o")=="" && !hasmapto('<plug>KrlTxtObjAroundFuncInclCo','o')
    omap <silent><buffer> aF <plug>KrlTxtObjAroundFuncInclCo
  endif
  if get(g:,'krlFunctionTextObject',0)
        \|| mapcheck("af","o")=="" && !hasmapto('<plug>KrlTxtObjAroundFuncExclCo','o')
    omap <silent><buffer> af <plug>KrlTxtObjAroundFuncExclCo
  endif
  if get(g:,'krlFunctionTextObject',0)
        \|| mapcheck("if","o")=="" && !hasmapto('<plug>KrlTxtObjInnerFunc','o')
    omap <silent><buffer> if <plug>KrlTxtObjInnerFunc
  endif
  " inner and around comment text objects
  if get(g:,'krlCommentTextObject',0)
        \|| mapcheck("ac","x")=="" && !hasmapto('<plug>KrlTxtObjAroundComment','x')
    xmap <silent><buffer> ac <plug>KrlTxtObjAroundComment
  endif
  if get(g:,'krlCommentTextObject',0)
        \|| mapcheck("ic","x")=="" && !hasmapto('<plug>KrlTxtObjInnerComment','x')
    xmap <silent><buffer> ic <plug>KrlTxtObjInnerComment
  endif
  if get(g:,'krlCommentTextObject',0)
        \|| mapcheck("ac","o")=="" && !hasmapto('<plug>KrlTxtObjAroundComment','o')
    omap <silent><buffer> ac <plug>KrlTxtObjAroundComment
  endif
  if get(g:,'krlCommentTextObject',0)
        \|| mapcheck("ic","o")=="" && !hasmapto('<plug>KrlTxtObjInnerComment','o')
    omap <silent><buffer> ic <plug>KrlTxtObjInnerComment
  endif
endif

" }}} Move Around and Function Text Object key mappings

" Other configurable key mappings {{{

" if the mapping does not exist and there is no plug-mapping just map it,
" otherwise look for the config variable

if has("folding")
  if get(g:,'krlFoldingKeyMap',0) 
        \|| mapcheck("<F2>","n")=="" && mapcheck("<F3>","n")=="" && mapcheck("<F4>","n")==""
        \&& !hasmapto('<plug>KrlCloseAllFolds','n') && !hasmapto('<plug>KrlCloseLessFolds','n') && !hasmapto('<plug>KrlCloseNoFolds','n')
    " close all folds
    nmap <silent><buffer> <F4> <plug>KrlCloseAllFolds
    " close move folds
    nmap <silent><buffer> <F3> <plug>KrlCloseLessFolds
    " open all folds
    nmap <silent><buffer> <F2> <plug>KrlCloseNoFolds
  endif
endif

" }}} Configurable mappings

" <PLUG> mappings {{{

" Function Text Object
if get(g:,'krlMoveAroundKeyMap',1) " depends on move around key mappings
  xnoremap <silent><buffer> <plug>KrlTxtObjAroundFuncInclCo :<C-U>call krl#FunctionTextObject(0,1)<CR>
  xnoremap <silent><buffer> <plug>KrlTxtObjAroundFuncExclCo :<C-U>call krl#FunctionTextObject(0,0)<CR>
  xnoremap <silent><buffer> <plug>KrlTxtObjInnerFunc        :<C-U>call krl#FunctionTextObject(1,0)<CR>
  onoremap <silent><buffer> <plug>KrlTxtObjAroundFuncInclCo :<C-U>call krl#FunctionTextObject(0,1)<CR>
  onoremap <silent><buffer> <plug>KrlTxtObjAroundFuncExclCo :<C-U>call krl#FunctionTextObject(0,0)<CR>
  onoremap <silent><buffer> <plug>KrlTxtObjInnerFunc        :<C-U>call krl#FunctionTextObject(1,0)<CR>
endif

" comment text objects
if get(g:,'krlMoveAroundKeyMap',1) " depends on move around key mappings
  xnoremap <silent><buffer> <plug>KrlTxtObjAroundComment     :<C-U>call krl#CommentTextObject(1)<CR>
  xnoremap <silent><buffer> <plug>KrlTxtObjInnerComment      :<C-U>call krl#CommentTextObject(0)<CR>
  onoremap <silent><buffer> <plug>KrlTxtObjAroundComment     :<C-U>call krl#CommentTextObject(1)<CR>
  onoremap <silent><buffer> <plug>KrlTxtObjInnerComment      :<C-U>call krl#CommentTextObject(0)<CR>
endif

" folding
if has("folding")
  nnoremap <silent><buffer> <plug>KrlCloseAllFolds  :setlocal foldexpr=krl#FoldExpr(v:lnum,2) foldlevel=0<CR>
  nnoremap <silent><buffer> <plug>KrlCloseLessFolds :setlocal foldexpr=krl#FoldExpr(v:lnum,1) foldlevel=0<CR>
  nnoremap <silent><buffer> <plug>KrlCloseNoFolds   :setlocal foldexpr=krl#FoldExpr(v:lnum,0) foldlevel=0<CR>
endif

" fold text objects
if exists("loaded_matchit") " depends on matchit (or matchup)
  xnoremap <silent><buffer> <plug>KrlTxtObjAroundFold     :<C-U>call krl#FoldTextObject(0)<CR>
  xnoremap <silent><buffer> <plug>KrlTxtObjInnerFold      :<C-U>call krl#FoldTextObject(1)<CR>
  onoremap <silent><buffer> <plug>KrlTxtObjAroundFold     :<C-U>call krl#FoldTextObject(0)<CR>
  onoremap <silent><buffer> <plug>KrlTxtObjInnerFold      :<C-U>call krl#FoldTextObject(1)<CR>
endif

" }}} <plug> mappings

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
