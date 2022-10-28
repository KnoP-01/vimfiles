" Vim autoload file
" Language: Helper functions used for Kuka Robot Language, ABB RAPID and maybe others
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 3.0.0
" Last Change: 14. Jun 2022

" Init {{{
if exists("g:loaded_knop_extras")
  finish
endif
let g:loaded_knop_extras = 1

let s:keepcpo = &cpo
set cpo&vim
" }}} Init 

function knop_extras#VerboseEcho(msg, ...) abort
  if get(g:,'knopVerbose',0)
    if type(a:msg) == v:t_list
      let l:msg = a:msg
    elseif type(a:msg) == v:t_string
      let l:msg = split(a:msg, "\n")
    else
      return
    endif
    for l:i in l:msg
      echomsg l:i
    endfor
    if exists('a:1')
      " for some reason I don't understand this has to be present twice
      call input("Hit enter> ")
      call input("Hit enter> ")
    endif
  endif
endfunction

function knop_extras#DirExists(in) abort
  if finddir( substitute(a:in,'\\','','g') )!=''
    return 1
  endif
  return 0
endfunction

function knop_extras#Fnameescape4Path(in) abort
  " escape a path for use as 'execute "set path=" . knop_extras#Fnameescape4Path(mypath)'
  " use / (not \) as a separator for the input parameter
  let l:out = fnameescape( a:in )
  let l:out = substitute(l:out, '\\#', '#', "g") " # and % will get escaped by fnameescape() but must not be escaped for set path...
  let l:out = substitute(l:out, '\\%', '%', "g")
  if !has("win32")
    let l:out = substitute(l:out, '\$', '\\$', "g") " escape $ sign only on none windows
  endif
  let l:out = substitute(l:out, '\\ ', '\\\\\\ ', 'g') " escape spaces with three backslashes
  let l:out = substitute(l:out, ',', '\\\\,', 'g') " escape comma and semicolon with two backslashes
  let l:out = substitute(l:out, ';', '\\\\;', "g")
  return l:out
endfunction

function s:knopCompleteEnbMsg() abort
  if exists("g:knopCompleteMsg")
    unlet g:knopCompleteMsg
    call knop_extras#VerboseEcho("Add the following files to 'complete'.\n  Try <Ctrl-p> and <Ctrl-n> to complete words from there:")
  endif
endfunction

function knop_extras#SplitAndUnescapeCommaSeparatedPathStr(commaSeparatedPathStr) abort
  let l:pathList = []
  for l:pathItem in split(a:commaSeparatedPathStr,'\\\@1<!,')
    if l:pathItem != ''
      call add(l:pathList,substitute(l:pathItem,'\\','','g'))
    endif
  endfor
  return l:pathList
endfunction

function knop_extras#AddFileToCompleteOption(file,pathList,...) abort
  let l:file=a:file
  for l:path in a:pathList
    let l:path = substitute(l:path,'[\\/]\*\*$','','')
    if l:path != ''
      if filereadable(l:path.'/'.l:file)!=''
        let l:f = knop_extras#Fnameescape4Path(l:path.'/'.l:file)
        call s:knopCompleteEnbMsg()
        if exists("g:knopCompleteMsg2")|call knop_extras#VerboseEcho(l:f)|endif
        execute 'setlocal complete+=k'.l:f
        return
      else
      endif
    else
    endif
  endfor
  if exists('a:1')
    let l:f = a:1
    if filereadable(l:f)!=''
      let l:f = knop_extras#Fnameescape4Path(a:1)
      call s:knopCompleteEnbMsg()
      if exists("g:knopCompleteMsg2")|call knop_extras#VerboseEcho(l:f)|endif
      execute 'setlocal complete+=k'.l:f
      return
    else
    endif
  endif
endfunction

function knop_extras#SubStartToEnd(search,sub,start,end) abort
  execute 'silent '. a:start .','. a:end .' s/'. a:search .'/'. a:sub .'/ge'
  call cursor(a:start,0)
endfunction

function knop_extras#UpperCase(start,end) abort
  call cursor(a:start,0)
  execute "silent normal! gU" . (a:end - a:start) . "j"
  call cursor(a:start,0)
endfunction

" taken from Peter Oddings
" function! xolox#misc#list#unique(list)
" xolox/misc/list.vim
function knop_extras#UniqueListItems(list) abort
  " Remove duplicate values from the given list in-place (preserves order).
  call reverse(a:list)
  call filter(a:list, 'count(a:list, v:val) == 1')
  return reverse(a:list)
endfunction

function knop_extras#PreparePath(path,file) abort
  " prepares 'path' for use with vimgrep
  let l:path = substitute(a:path,'$',' ','') " make sure that space is the last char
  let l:path = substitute(l:path,'\v(^|[^\\])\zs,+',' ','g') " separate with spaces instead of comma
  let l:path = substitute(l:path, '\\,', ',', "g") " unescape comma and semicolon
  let l:path = substitute(l:path, '\\;', ';', "g")
  let l:path = substitute(l:path, "#", '\\#', "g") " escape #, % and `
  let l:path = substitute(l:path, "%", '\\%', "g")
  let l:path = substitute(l:path, '`', '\\`', "g")
  " let l:path = substitute(l:path, '{', '\\{', "g") " I don't get curly braces to work
  " let l:path = substitute(l:path, '}', '\\}', "g")
  let l:path = substitute(l:path, '\*\* ', '**/'.a:file.' ', "g") " append a / to **, . and ..
  let l:path = substitute(l:path, '\.\. ', '../'.a:file.' ', "g")
  let l:path = substitute(l:path, '\. ', './'.a:file.' ', "g")
  call knop_extras#VerboseEcho('path prepared: ' . l:path)
  return l:path
endfunction

function knop_extras#QfCompatible() abort
  " check for qf.vim compatiblity
  if exists('g:loaded_qf') && get(g:,'qf_window_bottom',1)
        \&& (get(g:,'knopRhsQuickfix',0)
        \||  get(g:,'knopLhsQuickfix',0))
    call knop_extras#VerboseEcho("NOTE: \nIf you use qf.vim then g:knopRhsQuickfix and g:knopLhsQuickfix will not work unless g:qf_window_bottom is 0 (Zero). \nTo use g:knop[RL]hsQuickfix put this in your .vimrc: \n  let g:qf_window_bottom = 0\n\n",1)
    return 0
  endif
  return 1
endfunction

function! KnopEraseQFPaths(info) abort
  let l:items = getqflist({'id': a:info.id, 'items': 1}).items
  let l:resultQF = []
  for l:idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
    let l:item = l:items[l:idx]
    call add(l:resultQF, item.text[l:item.col - 1 : ])
  endfor
  return l:resultQF
endfunction

function! KnopFormatQFPaths(info) abort
  let l:items = getqflist({'id': a:info.id, 'items': 1}).items
  let l:resultQF = []
  for l:idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
    let l:item = l:items[l:idx]
    let l:line = fnamemodify(bufname(l:item.bufnr),':.')
    if get(g:,'knopShortenQFPath',1) && strlen(l:line)>40
      let l:line = pathshorten(l:line,5)
    endif
    let l:line .= "|" . l:item.lnum . " col " . l:item.col . "| "
    let l:line .= l:item.text
    call add( l:resultQF, l:line )
  endfor
  return l:resultQF
endfunction

let g:knopPositionQf=1
function knop_extras#OpenQf(useSyntax,...) abort
  if getqflist()==[] | return -1 | endif
  if !exists("a:1")
    call setqflist([], ' ', {'items' : getqflist(), 'quickfixtextfunc' : 'KnopFormatQFPaths', 'nr': "$"})
  endif
  cwindow 4
  if getbufvar('%', "&buftype")!="quickfix"
    let l:getback=1
    copen
  endif
  augroup KnopOpenQf
    au!
    " reposition after closing
    execute 'au BufWinLeave <buffer='.bufnr('%').'> let g:knopPositionQf=1'
  augroup END
  if a:useSyntax!='' 
    execute 'set syntax='.a:useSyntax 
  endif
  if exists('g:knopPositionQf') && knop_extras#QfCompatible() 
    unlet g:knopPositionQf
    if get(g:,'knopRhsQuickfix',0)
      wincmd L
    elseif get(g:,'knopLhsQuickfix',0)
      wincmd H
    endif
  endif
  if exists("l:getback")
    unlet l:getback
    wincmd p
  endif
  return 0
endfunction

function knop_extras#SearchPathForPatternNTimes(Pattern,path,n,useSyntax) abort
  call setqflist([])
  try
    call knop_extras#VerboseEcho("try: ".':noautocmd ' . a:n . 'vimgrep /' . a:Pattern . '/j ' . a:path)
    execute ':noautocmd ' . a:n . 'vimgrep /' . a:Pattern . '/j ' . a:path
  catch /^Vim\%((\a\+)\)\=:E303/
    call knop_extras#VerboseEcho(":vimgrep stopped with E303. No match found")
    return -1
  catch /^Vim\%((\a\+)\)\=:E479/
    call knop_extras#VerboseEcho(":vimgrep stopped with E479. No match found")
    return -1
  catch /^Vim\%((\a\+)\)\=:E480/
    call knop_extras#VerboseEcho(":vimgrep stopped with E480. No match found")
    return -1
  catch /^Vim\%((\a\+)\)\=:E683/
    call knop_extras#VerboseEcho(":vimgrep stopped with E683. No match found")
    return -1
  endtry
  call setqflist(knop_extras#UniqueListItems(getqflist()))
  if knop_extras#OpenQf(a:useSyntax)==-1
    call knop_extras#VerboseEcho("No match found")
    return -1
  endif
  return 0
endfunction

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
