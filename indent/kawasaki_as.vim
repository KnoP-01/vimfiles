" Vim indent file
" Language: Kawasaki AS-language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 23. Mar 2023

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal nocindent
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=GetAsIndent()
setlocal indentkeys=!^F,o,O,=~end,0=~else,0=~value,0=~any
let b:undo_indent = "setlocal lisp< cindent< smartindent< autoindent< indentexpr< indentkeys<"

if get(g:,'asSpaceIndent',1)
  " Use spaces, not tabs, for indention, 2 is enough. 
  " More or even tabs would waste valuable space on the teach pendant.
  setlocal softtabstop=2
  setlocal shiftwidth=2
  setlocal expandtab
  setlocal shiftround
  let b:undo_indent = b:undo_indent." softtabstop< shiftwidth< expandtab< shiftround<"
endif

" Only define the function once.
if exists("*GetAsIndent")
  finish
endif

let s:keepcpo = &cpo
set cpo&vim

function GetAsIndent() abort

  let currentLine = getline(v:lnum)
  if  currentLine =~? '^;' && !get(g:, 'asCommentIndent', 1)
    " If current line has a ; in column 1 and is no fold, keep zero indent.
    " This may be usefull if code is commented out at the first column.
    return 0
  endif

  " Find a non-blank line above the current line.
  let preNoneBlankLineNum = s:AsPreNoneBlank(v:lnum - 1)
  if  preNoneBlankLineNum == 0
    " At the start of the file use zero indent.
    return 0
  endif

  let preNoneBlankLine = getline(preNoneBlankLineNum)
  let ind = indent(preNoneBlankLineNum)

  " Define add 'shiftwidth' pattern
  let addShiftwidthPattern =           '\c\v^\s*('
  if get(g:, 'asIndentBetweenDef', 1)
    let addShiftwidthPattern ..=               '\.program>'
    let addShiftwidthPattern ..=               '|'
  endif
  let addShiftwidthPattern   ..=               'if>|while>|for>'
  let addShiftwidthPattern   ..=               '|else>'
  let addShiftwidthPattern   ..=               '|value>|any>'
  let addShiftwidthPattern   ..=             ')'

  " Define Subtract 'shiftwidth' pattern
  let subtractShiftwidthPattern =      '\c\v^\s*('
  if get(g:, 'asIndentBetweenDef', 1)
    let subtractShiftwidthPattern ..=          '\.end>'
    let subtractShiftwidthPattern ..=          '|'
  endif
  let subtractShiftwidthPattern   ..=          'end>'
  let subtractShiftwidthPattern   ..=          '|else(if)?>'
  let subtractShiftwidthPattern   ..=          '|value>|any>>'
  let subtractShiftwidthPattern   ..=        ')'

  " Add shiftwidth
  if preNoneBlankLine =~? addShiftwidthPattern
    let ind += &sw
  endif

  " Subtract shiftwidth
  if currentLine =~? subtractShiftwidthPattern
    let ind = ind - &sw
  endif

  " First value after a case gets the indent of the case.
  if currentLine =~? '\c\v^\s*value>'
        \&& preNoneBlankLine =~? '\c\v^\s*case>'
    let ind = ind + &sw
  endif

  return ind
endfunction

" This function works almost like prevnonblank() but handles
" comments like blank lines
function s:AsPreNoneBlank(lnum) abort

  let nPreNoneBlank = prevnonblank(a:lnum)

  while nPreNoneBlank > 0 && getline(nPreNoneBlank) =~? '^\s*;'
    " Previouse none blank line a comment. Look further aback.
    let nPreNoneBlank = prevnonblank(nPreNoneBlank - 1)
  endwhile

  return nPreNoneBlank
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et
