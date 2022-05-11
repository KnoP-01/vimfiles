" Vim autoload file
" Language: Kuka Robot Language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 3.0.0
" Last Change: 11. May 2022

" Init {{{
if exists("g:loaded_krl")
  finish
endif
let g:loaded_krl = 1

let s:keepcpo = &cpo
set cpo&vim
" }}} Init 

" VKRC {{{
function krl#IsVkrc() abort
  if exists("b:krlIsVkrc")
    return b:krlIsVkrc
  endif
  if bufname("%") =~? '\v(folge|up|makro(saw|sps|step|trigger)?)\d*\.src'
  " if bufname("%") =~? '\v%(folge|up)\d+\.src$'
    for l:s in range(1, 8)
      if getline(l:s) =~? '\v^\s*\&param\s+tpvw_version>'
        let b:krlIsVkrc = 1
        return 1
      endif
    endfor
  endif
  let b:krlIsVkrc = 0
  return 0
endfunction

function krl#IsVkrcFolgeOrUP() abort
  return krl#IsVkrc() && bufname("%") =~? '\v%(folge|up)\d+\.src$'
endfunction
" }}} VKRC

" Folding {{{
function krl#FoldText() abort
  return substitute( substitute( getline(v:foldstart), '\v\c%(;\s*FOLD>\s+|;[^;]*$)', '', 'g'), '\(.*\)', '\1 -----', 'g')
endfunction

function s:FoldLevelFirstLine(line, patternFold) abort
  if a:line =~? a:patternFold
    return 1
  endif
  return 0
endfunction

function s:FoldLevel(do, lnum, returnLiteral) abort

  let foldLevelPrevLine = foldlevel(a:lnum - 1)
  if  foldLevelPrevLine < 0 || a:returnLiteral
    return a:do
  endif

  let foldLevelChange = 0
  if     a:do == "a1"
    let foldLevelChange = 1
  elseif a:do == "s1"
    let foldLevelChange = (-1)
  endif

  return foldLevelPrevLine + foldLevelChange
endfunction

function s:Return_S1_OnMoveEndFold(lnum, patternAnyFold, patternMoveFold, patternEndFold) abort

  let foundEndfold = 1

  " look backwards to find matching fold
  for i in reverse(range(1, a:lnum-1))

    if getline(i) =~? a:patternEndFold
      let foundEndfold += 1
    endif

    if getline(i) =~? a:patternAnyFold 
      let foundEndfold -=1
    endif

    if foundEndfold == 0
      if getline(i) =~? a:patternMoveFold
        " Return "s1" for movement fold.
        " Always return literal "s1" for any kind of endfold
        return "s1"
      endif
      break
    endif

  endfor

  " return = for any other fold
  let dontReturnLiteral = v:false
  return s:FoldLevel("=", a:lnum, dontReturnLiteral)
endfunction

function krl#FoldExpr(lnum, krlFoldLevel) abort

  if a:lnum < 1 || a:lnum > line("$") || a:krlFoldLevel == 0
    return 0
  endif

  if krl#IsVkrc() && a:krlFoldLevel <= 1
    let patternAnyFold  = '\v^\s*;\s*FOLD>%(\s+S?%(LIN|PTP|CIRC)%(_REL)?)@!'
  else
    let patternAnyFold  = '\v^\s*;\s*FOLD>'
  endif
  let patternMoveFold = '\v^\s*;\s*FOLD>.*<%(S?%(LIN|PTP|CIRC)%(_REL)?|Parameters)>'
  let patternEndFold  = '\v^\s*;\s*ENDFOLD>'
  let line = getline(a:lnum)
  if a:lnum > 1
    " we are not in line 1, look for previous line as well
    let prevLine = getline(a:lnum - 1)
  endif
  let returnLiteral = (prevLine =~? patternAnyFold || prevLine =~? patternEndFold)

  if krl#IsVkrc() || a:krlFoldLevel == 2

    if a:lnum == 1
      return s:FoldLevelFirstLine(line, patternAnyFold)
    endif

    if line =~? patternAnyFold
      return s:FoldLevel("a1", a:lnum, returnLiteral)
    endif

    if line =~? patternEndFold 
      " Always return literal "s1" for any kind of endfold
      return "s1"
    endif

  elseif a:krlFoldLevel == 1

    if a:lnum == 1
      return s:FoldLevelFirstLine(line, patternMoveFold)
    endif

    if line =~? patternMoveFold
      return s:FoldLevel("a1", a:lnum, returnLiteral)
    endif

    if line =~? patternEndFold
      return s:Return_S1_OnMoveEndFold(a:lnum, patternAnyFold, patternMoveFold, patternEndFold)
    endif

  endif

  return s:FoldLevel("=", a:lnum, returnLiteral)
endfunction
" }}} Folding

" Function Text Object {{{
if get(g:, 'krlMoveAroundKeyMap', 1) " depends on move around key mappings
  function krl#FunctionTextObject(inner,withcomment) abort
    if a:inner==1
      let l:n = 1
    else
      let l:n = v:count1
    endif
    if getline('.')!~'\v\c^\s*end(fct|dat)?>'
      silent normal ][
    endif
    silent normal [[
    silent normal! zz
    if a:inner==1
      silent normal! j
    elseif a:withcomment==1
      while line('.')>1 && getline(line('.')-1)=~'\v\c^\s*;(\s*(end)?fold)@!'
        silent normal! k
      endwhile
    endif
    exec "silent normal V".l:n."]["
    if a:inner==1
      silent normal! k
    elseif a:withcomment==1 && getline(line('.')+1)=~'^\s*$'
      silent normal! j
    endif
  endfunction
endif
" }}} Function Text Object

" Comment Text Object {{{
if get(g:, 'krlMoveAroundKeyMap', 1) " depends on move around key mappings
  function krl#CommentTextObject(around) abort
    if getline('.')!~'^\s*;' && !search('^\s*;',"sW")
      return
    endif
    " starte innerhalb des oder nach dem kommentar
    silent normal! j
    silent normal [;
    silent normal! V
    if getline(line('.')+1) =~ '^\s*;'
      silent normal ];
    endif
    if a:around && getline(line('.')+1)=~'^\s*$'
      silent normal! j
    endif
  endfunction
endif
" }}} Comment Text Object

" Fold Text Object {{{
if exists("loaded_matchit") " depends on matchit (or matchup)
  function krl#FoldTextObject(inner) abort
    let l:col = col('.')
    let l:line = line('.')
    let l:foundFold = 0
    let l:nEndfolds = v:count1
    if getline('.')=~'\c^\s*;\s*fold\>'
          \&& l:nEndfolds>1
      " starte innerhalb des fold
      silent normal! j
    endif
    if getline('.')!~'\c^\s*;\s*fold\>' || l:nEndfolds>1 && search('\c^\s*;\s*fold\>','bnW')
      while l:foundFold==0 && line('.')>1 && search('\c^\s*;\s*fold\>','bcnW')
        silent normal! k
        if getline(line('.'))=~'\c^\s*;\s*endfold\>'
          let l:nEndfolds+=1
        endif
        if getline(line('.'))=~'\c^\s*;\s*fold\>'
          let l:nEndfolds-=1
          if l:nEndfolds==0
            let foundFold=1
          endif
        endif
      endwhile
    else
      let l:foundFold=1
    endif
    if l:foundFold==1
      silent normal 0V%
      if a:inner == 1
        silent normal! k
        " ggf fold oeffnen der innerhalb des fold ist dessen inhalt geloescht werden soll 
        silent! normal! zo
        normal! '<
        silent normal 0V%
        " eigentlich will ich an der stelle nur <esc> druecken um die visual
        " selection wieder abzubrechen, aber das funktioniert irgendwie
        " nicht, also dieser hack
        silent normal! :<C-U><CR>
        silent normal! j
        silent normal! V
        silent normal! '>
        silent normal! k
      endif
    else
      call cursor(l:line,l:col)
    endif
  endfunction
endif
" }}} Fold Text Object

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
