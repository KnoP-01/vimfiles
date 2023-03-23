" Vim autoload file
" Language: Helper functions used for Kuka Robot Language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 3.0.0
" Last Change: 30. Jan 2023

" Init {{{
if exists("g:loaded_krl_extras")
  finish
endif
let g:loaded_krl_extras = 1

let s:keepcpo = &cpo
set cpo&vim
" }}} Init 

" FIX ME: Hier wird global iskeyword gesetzt aber nur das buffer local
" iskeyword wieder zurueck gesetzt
function krl_extras#AlterIsKeyWord(force) abort
  if !get(g:,'krlKeyWord',1) || a:force
    " temporary set iskeyword
    let s:keepIsKeyWordBufNr = bufnr("%")
    let s:keepIsKeyWord = &iskeyword
    set iskeyword+=#,$,&
  endif
endfunction

function krl_extras#ResetIsKeyWord() abort
  if exists("s:keepIsKeyWord")
    " reset iskeyword too keept value if altered
    call setbufvar(s:keepIsKeyWordBufNr, "&iskeyword", s:keepIsKeyWord)
    unlet s:keepIsKeyWord
    unlet s:keepIsKeyWordBufNr
  endif
endfunction

function krl_extras#PathWithGlobalDataLists() abort
  call setloclist(0,[])
  try
    execute ':noautocmd lvimgrep /\c\v^\s*defdat\s+(\w+\s+public|\$\w+)/j ' . knop_extras#PreparePath(&path,'*.[dD][aA][tT]')
  catch /^Vim\%((\a\+)\)\=:E479/
    call knop_extras#VerboseEcho(":lvimgrep stopped with E479! No global data lists found in \'path\'.")
    return ' '
  catch /^Vim\%((\a\+)\)\=:E480/
    call knop_extras#VerboseEcho(":lvimgrep stopped with E480! No global data lists found in \'path\'.")
    return ' '
  catch /^Vim\%((\a\+)\)\=:E683/
    call knop_extras#VerboseEcho(":lvimgrep stopped with E683! No global data lists found in \'path\'.")
    return ' '
  endtry
  let l:locationList = getloclist(0)
  let l:path = ' '
  for l:loc in l:locationList
    let l:path = l:path . fnameescape(bufname(l:loc.bufnr)) . " "
  endfor
  call knop_extras#VerboseEcho("Global Data Lists: ".l:path)
  return l:path
endfunction

function krl_extras#CurrentWordIs() abort
  " returns the string "<type><name>" depending on the word under the cursor
  "
  let l:numLine = line(".")
  let l:strLine = getline(".")
  "
  " position the cursor at the start of the current word
  call krl_extras#AlterIsKeyWord(0)
  if search('\<','bcsW',l:numLine)
    "
    " init
    let l:numCol = col(".")
    let l:currentChar = strpart(l:strLine, l:numCol-1, 1)
    let l:strUntilCursor = strpart(l:strLine, 0, l:numCol-1)
    let l:lenStrUntilCursor = strlen(l:strUntilCursor)
    "
    " find next char
    if search('\>\s*.',"eW",l:numLine)
      let l:nextChar = strpart(l:strLine, col(".")-1, 1)
    else
      let l:nextChar = ""
    endif
    "
    " set cursor back to start of word
    call cursor(l:numLine,l:numCol)
    "
    " get word at cursor
    let l:word = expand("<cword>")
    call krl_extras#ResetIsKeyWord()
    "
    " count string chars " before the current char
    let l:i = 0
    let l:countStrChr = 0
    while l:i < l:lenStrUntilCursor
      let l:i = stridx(l:strUntilCursor, "\"", l:i)
      if l:i >= 0
        let l:i = l:i+1
        let l:countStrChr = l:countStrChr+1
      else
        let l:i = l:lenStrUntilCursor+1
      endif
    endwhile
    let l:countStrChr = l:countStrChr%2
    "
    " return something
    if search(';','bcnW',l:numLine)
      return ("comment" . l:word)
      "
    elseif l:countStrChr == 1
      if l:strUntilCursor =~ '\c\<varstate\s*(\s*"$'
        return ("var" . l:word)
      endif
      return ("string" . l:word)
      "
    elseif l:currentChar == "$"
      return ("sysvar" . l:word)
      "
    elseif l:currentChar == "&"
      return ("header" . l:word)
      "
    elseif l:currentChar == "#"
      return ("enumval" . l:word)
      "
    elseif l:word =~ '\v\c^(true|false)>'
      return ("bool" . l:word)
      "
    elseif l:currentChar =~ '\d' ||
          \(l:word=~'^[bB][10]\+$' &&
          \   (synIDattr(synID(line("."),col("."),0),"name")=="krlBinaryInt"
          \ || synIDattr(synID(line("."),col("."),0),"name")=="")
          \|| l:word=~'^[hH][0-9a-fA-F]\+$' &&
          \   (synIDattr(synID(line("."),col("."),0),"name")=="krlHexInt"
          \ || synIDattr(synID(line("."),col("."),0),"name")=="")
          \) && l:nextChar == "'"
      return ("num" . l:word)
      "
    elseif l:nextChar == "(" &&
          \(  synIDattr(synID(line("."),col("."),0),"name")=="krlFunction"
          \|| synIDattr(synID(line("."),col("."),0),"name")=="krlBuildInFunction"
          \|| synIDattr(synID(line("."),col("."),0),"name")==""
          \)
      if search('\c\v(<do>|<def>)\s*'.l:word,'bnW',l:numLine) || !search('[^\t ]','bnW',l:numLine)
        if synIDattr(synID(line("."),col("."),0),"name") != "krlBuildInFunction"
          return ("proc" . l:word)
          "
        else
          return ("sysproc" . l:word)
          "
        endif
      else
        if synIDattr(synID(line("."),col("."),0),"name") != "krlBuildInFunction"
          return ("func" . l:word)
          "
        else
          return ("sysfunc" . l:word)
          "
        endif
      endif
    else
      if        synIDattr(synID(line("."),col("."),0),"name") != "krlNames"
            \&& synIDattr(synID(line("."),col("."),0),"name") != "krlSysvars"
            \&& synIDattr(synID(line("."),col("."),0),"name") != "krlStructure"
            \&& synIDattr(synID(line("."),col("."),0),"name") != "krlEnum"
            \&& synIDattr(synID(line("."),col("."),0),"name") != ""
        return ("inst" . l:word)
        "
      else
        return ("var" . l:word)
        "
      endif
    endif
  endif
  call krl_extras#ResetIsKeyWord()
  return "none"
endfunction

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
