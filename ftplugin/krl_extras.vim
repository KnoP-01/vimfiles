" Vim file type plugin
" Language: Kuka Robot Language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 3.0.0
" Last Change: 18. May 2022
"
" ToDo's {{{
" }}} ToDo's

" Init {{{
let s:keepcpo = &cpo
set cpo&vim
" }}} init

" only declare functions once
if !exists("*s:KnopVerboseEcho()")

  " Little Helper {{{

  if get(g:,'knopVerbose',0)
    let g:knopCompleteMsg = 1
    let g:knopCompleteMsg2 = 1
    let g:knopVerboseMsg = 1
  endif
  if exists('g:knopVerboseMsg')
    unlet g:knopVerboseMsg
    echomsg "Switch verbose messages off with \":let g:knopVerbose=0\" any time. You may put this in your .vimrc"
  endif
  function s:KnopVerboseEcho(msg, ...) abort
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
  endfunction " s:KnopVerboseEcho()

  function s:KnopDirExists(in) abort
    if finddir( substitute(a:in,'\\','','g') )!=''
      return 1
    endif
    return 0
  endfunction " s:KnopDirExists

  function s:KnopFnameescape4Path(in) abort
    " escape a path for use as 'execute "set path=" . s:KnopFnameescape4Path(mypath)'
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
      call s:KnopVerboseEcho("Add the following files to 'complete'.\n  Try <Ctrl-p> and <Ctrl-n> to complete words from there:")
    endif
  endfunction " s:knopCompleteEnbMsg

  function s:KnopSplitAndUnescapeCommaSeparatedPathStr(commaSeparatedPathStr) abort
    let l:pathList = []
    for l:pathItem in split(a:commaSeparatedPathStr,'\\\@1<!,')
      if l:pathItem != ''
        call add(l:pathList,substitute(l:pathItem,'\\','','g'))
      endif
    endfor
    return l:pathList
  endfunction

  function s:KnopAddFileToCompleteOption(file,pathList,...) abort
    let l:file=a:file
    for l:path in a:pathList
      let l:path = substitute(l:path,'[\\/]\*\*$','','')
      if l:path != ''
        if filereadable(l:path.'/'.l:file)!=''
          let l:f = s:KnopFnameescape4Path(l:path.'/'.l:file)
          call s:knopCompleteEnbMsg()
          if exists("g:knopCompleteMsg2")|call s:KnopVerboseEcho(l:f)|endif
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
        let l:f = s:KnopFnameescape4Path(a:1)
        call s:knopCompleteEnbMsg()
        if exists("g:knopCompleteMsg2")|call s:KnopVerboseEcho(l:f)|endif
        execute 'setlocal complete+=k'.l:f
        return
      else
      endif
    endif
  endfunction " s:KnopAddFileToCompleteOption()

  function s:KnopSubStartToEnd(search,sub,start,end) abort
    execute 'silent '. a:start .','. a:end .' s/'. a:search .'/'. a:sub .'/ge'
    call cursor(a:start,0)
  endfunction " s:KnopSubStartToEnd()

  function s:KnopUpperCase(start,end) abort
    call cursor(a:start,0)
    execute "silent normal! gU" . (a:end - a:start) . "j"
    call cursor(a:start,0)
  endfunction " s:KnopUpperCase()

  " taken from Peter Oddings
  " function! xolox#misc#list#unique(list)
  " xolox/misc/list.vim
  function s:KnopUniqueListItems(list) abort
    " Remove duplicate values from the given list in-place (preserves order).
    call reverse(a:list)
    call filter(a:list, 'count(a:list, v:val) == 1')
    return reverse(a:list)
  endfunction " s:KnopUniqueListItems()

  function s:KnopPreparePath(path,file) abort
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
    call s:KnopVerboseEcho('path prepared: ' . l:path)
    return l:path
  endfunction " s:KnopPreparePath()

  function s:KnopQfCompatible() abort
    " check for qf.vim compatiblity
    if exists('g:loaded_qf') && get(g:,'qf_window_bottom',1)
          \&& (get(g:,'knopRhsQuickfix',0)
          \||  get(g:,'knopLhsQuickfix',0))
      call s:KnopVerboseEcho("NOTE: \nIf you use qf.vim then g:knopRhsQuickfix and g:knopLhsQuickfix will not work unless g:qf_window_bottom is 0 (Zero). \nTo use g:knop[RL]hsQuickfix put this in your .vimrc: \n  let g:qf_window_bottom = 0\n\n",1)
      return 0
    endif
    return 1
  endfunction " s:KnopQfCompatible()

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
  function s:KnopOpenQf(useSyntax,...) abort
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
    if exists('g:knopPositionQf') && s:KnopQfCompatible() 
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
  endfunction " s:KnopOpenQf()

  function s:KnopSearchPathForPatternNTimes(Pattern,path,n,useSyntax) abort
    call setqflist([])
    try
      call s:KnopVerboseEcho("try: ".':noautocmd ' . a:n . 'vimgrep /' . a:Pattern . '/j ' . a:path)
      execute ':noautocmd ' . a:n . 'vimgrep /' . a:Pattern . '/j ' . a:path
    catch /^Vim\%((\a\+)\)\=:E303/
      call s:KnopVerboseEcho(":vimgrep stopped with E303. No match found")
      return -1
    catch /^Vim\%((\a\+)\)\=:E479/
      call s:KnopVerboseEcho(":vimgrep stopped with E479. No match found")
      return -1
    catch /^Vim\%((\a\+)\)\=:E480/
      call s:KnopVerboseEcho(":vimgrep stopped with E480. No match found")
      return -1
    catch /^Vim\%((\a\+)\)\=:E683/
      call s:KnopVerboseEcho(":vimgrep stopped with E683. No match found")
      return -1
    endtry
    call setqflist(s:KnopUniqueListItems(getqflist()))
    if s:KnopOpenQf(a:useSyntax)==-1
      call s:KnopVerboseEcho("No match found")
      return -1
    endif
    return 0
  endfunction " s:KnopSearchPathForPatternNTimes()

  " }}} Little Helper

  " Krl Helper {{{

  function s:KrlAlterIsKeyWord(force) abort
    if !get(g:,'krlKeyWord',1) || a:force
      " temporary set iskeyword
      let s:keepIsKeyWordBufNr = bufnr("%")
      let s:keepIsKeyWord = &iskeyword
      set iskeyword+=#,$,&
    endif
  endfunction

  function s:KrlResetIsKeyWord() abort
    if exists("s:keepIsKeyWord")
      " reset iskeyword too keept value if altered
      call setbufvar(s:keepIsKeyWordBufNr, "&iskeyword", s:keepIsKeyWord)
      unlet s:keepIsKeyWord
      unlet s:keepIsKeyWordBufNr
    endif
  endfunction

  function s:KrlPathWithGlobalDataLists() abort
    call setloclist(0,[])
    try
      execute ':noautocmd lvimgrep /\c\v^\s*defdat\s+(\w+\s+public|\$\w+)/j ' . s:KnopPreparePath(&path,'*.[dD][aA][tT]')
    catch /^Vim\%((\a\+)\)\=:E479/
      call s:KnopVerboseEcho(":lvimgrep stopped with E479! No global data lists found in \'path\'.")
      return ' '
    catch /^Vim\%((\a\+)\)\=:E480/
      call s:KnopVerboseEcho(":lvimgrep stopped with E480! No global data lists found in \'path\'.")
      return ' '
    catch /^Vim\%((\a\+)\)\=:E683/
      call s:KnopVerboseEcho(":lvimgrep stopped with E683! No global data lists found in \'path\'.")
      return ' '
    endtry
    let l:locationList = getloclist(0)
    let l:path = ' '
    for l:loc in l:locationList
      let l:path = l:path . fnameescape(bufname(l:loc.bufnr)) . " "
    endfor
    call s:KnopVerboseEcho("Global Data Lists: ".l:path)
    return l:path
  endfunction " s:KrlPathWithGlobalDataLists()

  function s:KrlCurrentWordIs() abort
    " returns the string "<type><name>" depending on the word under the cursor
    "
    let l:numLine = line(".")
    let l:strLine = getline(".")
    "
    " position the cursor at the start of the current word
    call s:KrlAlterIsKeyWord(0)
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
      call s:KrlResetIsKeyWord()
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
    call s:KrlResetIsKeyWord()
    return "none"
  endfunction " s:KrlCurrentWordIs()

  " }}} krl Helper

  " Go Definition {{{

  function s:KrlSearchVkrcMarker(currentWord) abort
    call s:KnopVerboseEcho("Search marker definitions...")
    let l:markerNumber = substitute(a:currentWord,'\cm','','')
    if (s:KnopSearchPathForPatternNTimes('\c^\s*\$cycflag\s*\[\s*'.l:markerNumber.'\s*\]\s*=',s:KnopPreparePath(&path,'*.[sS][rR][cC]').' '.s:KnopPreparePath(&path,'*.[sS][uU][bB]'),'','krl') == 0)
      call setqflist(s:KnopUniqueListItems(getqflist()))
      call s:KnopOpenQf('krl')
      call s:KnopVerboseEcho("Marker definition found.",1)
      return 0
    endif
    call s:KnopVerboseEcho("Nothing found.",1)
    return -1
  endfunction

  function s:KrlSearchVkrcBin(currentWord) abort
    call s:KnopVerboseEcho("Search binary signal definitions...")
    let l:binNumber = substitute(a:currentWord,'\cbin\(in\)\?','','')
    if a:currentWord=~?'binin'
      if (s:KnopSearchPathForPatternNTimes('\v\c^\s*\$bin_in\[\s*'.l:binNumber.'\s*\]\s*\=',s:KrlPathWithGlobalDataLists(),'1','krl') == 0)
        call s:KnopOpenQf('krl')
        call s:KnopVerboseEcho("BIN_IN found.",1)
        return 0
      endif
    else
      if (s:KnopSearchPathForPatternNTimes('\v\c^\s*\$bin_out\[\s*'.l:binNumber.'\s*\]\s*\=',s:KrlPathWithGlobalDataLists(),'1','krl') == 0)
        call s:KnopOpenQf('krl')
        call s:KnopVerboseEcho("BIN_OUT found.",1)
        return 0
      endif
    endif
    call s:KnopVerboseEcho("Nothing found.",1)
    return -1
  endfunction

  function s:KrlSearchSysvar(declPrefix,currentWord) abort
    " a:currentWord starts with '$' so we need '\' at the end of declPrefix pattern
    call s:KnopVerboseEcho("Search global data lists...")
    if (s:KnopSearchPathForPatternNTimes(a:declPrefix.'\'.a:currentWord.">",s:KrlPathWithGlobalDataLists(),'1','krl') == 0)
      call s:KnopVerboseEcho("Found global data list declaration. The quickfix window will open. See :he quickfix-window",1)
      return 0
    endif
    call s:KnopVerboseEcho("Nothing found.",1)
    return -1
  endfunction " s:KrlSearchSysvar()

  function s:KrlSearchEnumVal(declPrefix,currentWord) abort
    "
    let l:qf = []
    " search corrosponding dat file
    call s:KnopVerboseEcho("Search local data list...")
    let l:filename = substitute(fnameescape(bufname("%")),'\c\.src$','.[dD][aA][tT]','')
    if filereadable(glob(l:filename))
      if (s:KnopSearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",l:filename,'','krl') == 0)
        call s:KnopVerboseEcho("Found local data list declaration. The quickfix window will open. See :he quickfix-window",1)
        let l:qf = getqflist()
        "
      endif
    else
      call s:KnopVerboseEcho(["File ",l:filename," not readable"])
    endif " search corrosponding dat file
    "
    " also search global data lists
    call s:KnopVerboseEcho("Search global data lists...")
    if (s:KnopSearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",s:KrlPathWithGlobalDataLists(),'','krl') == 0)
      call s:KnopVerboseEcho("Found global data list declaration. The quickfix window will open. See :he quickfix-window",1)
      let l:qf = l:qf + getqflist()
      "
    endif
    "
    if l:qf != []
      call setqflist(l:qf)
      if s:KnopOpenQf('krl')==-1
        call s:KnopVerboseEcho("No match found")
        return -1
      endif
      return 0
    endif
    "
    call s:KnopVerboseEcho("Nothing found.",1)
    return -1
  endfunction

  function s:KrlSearchVar(declPrefix,currentWord) abort
    "
    " first search for local declartion
    call s:KnopVerboseEcho("Search def(fct)? local declaration...")
    let l:numLine = line(".")
    let l:numCol = col(".")
    let l:numDefLine = search('\v\c^\s*(global\s+)?<def(fct|dat)?>','bW')
    let l:numEndLine = search('\v\c^\s*<end(fct|dat)?>','nW')
    if search(a:declPrefix.'\zs<'.a:currentWord.">","W",l:numEndLine)
      call s:KnopVerboseEcho("Found def(fct|dat)? local declaration. Get back where you came from with ''",1)
      return 0
      "
    else
      call s:KnopVerboseEcho("No match found")
      call cursor(l:numLine,l:numCol)
    endif
    "
    " second search corrosponding dat file
    call s:KnopVerboseEcho("Search local data list...")
    let l:filename = substitute(fnameescape(bufname("%")),'\c\.src$','.[dD][aA][tT]','')
    if filereadable(glob(l:filename))
      if (s:KnopSearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",l:filename,'1','krl') == 0)
        call s:KnopVerboseEcho("Found local data list declaration. The quickfix window will open. See :he quickfix-window",1)
        return 0
        "
      endif
    else
      call s:KnopVerboseEcho(["File ",l:filename," not readable"])
    endif " search corrosponding dat file
    "
    " third search global data lists
    call s:KnopVerboseEcho("Search global data lists...")
    if (s:KnopSearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",s:KrlPathWithGlobalDataLists(),'1','krl') == 0)
      call s:KnopVerboseEcho("Found global data list declaration. The quickfix window will open. See :he quickfix-window",1)
      return 0
      "
    endif
    "
    call s:KnopVerboseEcho("Nothing found.",1)
    return -1
  endfunction " s:KrlSearchVar()

  function s:KrlSearchProc(currentWord) abort
    "
    " first search for local def(fct)? declartion
    call s:KnopVerboseEcho("Search def(fct)? definitions in current file...")
    let l:numLine = line(".")
    let l:numCol = col(".")
    0
    if search('\c\v^\s*(global\s+)?def(fct\s+\w+(\[[0-9,]*\])?)?\s+\zs'.a:currentWord.'>','cw',"$")
      call s:KnopVerboseEcho("Found def(fct)? local declaration. Get back where you came from with ''",1)
      return 0
      "
    else
      call s:KnopVerboseEcho("No match found")
      call cursor(l:numLine,l:numCol)
    endif
    "
    " second search src file name = a:currentWord
    try
      let l:saved_fileignorecase = &fileignorecase
      setlocal fileignorecase
      call s:KnopVerboseEcho("Search .src files in &path...")
      let l:path = s:KnopPreparePath(&path,a:currentWord.'.[sS][rR][cC]').s:KnopPreparePath(&path,a:currentWord.'.[sS][uU][bB]')
      if !filereadable('./'.a:currentWord.'.[sS][rR][cC]') " suppress message about missing file
        let l:path = substitute(l:path, '\.[\\/]'.a:currentWord.'.\[sS\]\[rR\]\[cC\] ', ' ','g')
      endif
      if !filereadable('./'.a:currentWord.'.[sS][uU][bB]') " suppress message about missing file
        let l:path = substitute(l:path, '\.[\\/]'.a:currentWord.'.\[sS\]\[uU\]\[bB\] ', ' ','g')
      endif
      if (s:KnopSearchPathForPatternNTimes('\c\v^\s*(global\s+)?def(fct\s+\w+(\[[0-9,]*\])?)?\s+'.a:currentWord.">",l:path,'1','krl') == 0)
        call s:KnopVerboseEcho("Found src file. The quickfix window will open. See :he quickfix-window",1)
        return 0
        "
      endif
    finally
      let &fileignorecase = l:saved_fileignorecase
      unlet l:saved_fileignorecase
    endtry
    "
    " third search global def(fct)?
    call s:KnopVerboseEcho("Search global def(fct)? definitions in &path...")
    if (s:KnopSearchPathForPatternNTimes('\c\v^\s*global\s+def(fct\s+\w+(\[[0-9,]*\])?)?\s+'.a:currentWord.">",s:KnopPreparePath(&path,'*.[sS][rR][cC]').s:KnopPreparePath(&path,'*.[sS][uU][bB]'),'1','krl') == 0)
      call s:KnopVerboseEcho("Found global def(fct)? declaration. The quickfix window will open. See :he quickfix-window",1)
      return 0
      "
    endif
    "
    call s:KnopVerboseEcho("Nothing found.",1)
    return -1
  endfunction " s:KrlSearchProc()

  function <SID>KrlGoDefinition() abort
    "
    let l:declPrefix = '\c\v^\s*((global\s+)?(const\s+)?(bool|int|real|char|frame|pos|axis|e6pos|e6axis|signal|channel)\s+[a-zA-Z0-9_,\[\] \t]*|(decl\s+)?(global\s+)?(struc|enum)\s+|decl\s+(global\s+)?(const\s+)?\w+\s+[a-zA-Z0-9_,\[\] \t]*)'
    "
    " suche das naechste wort
    if search('\w','cW',line("."))
      "
      let l:currentWord = s:KrlCurrentWordIs()
      "
      if l:currentWord =~ '^sysvar.*'
        let l:currentWord = substitute(l:currentWord,'^sysvar','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a KSS VARIABLE"])
        return s:KrlSearchSysvar(l:declPrefix,l:currentWord)
        "
      elseif l:currentWord =~ '^var.*'
        let l:currentWord = substitute(l:currentWord,'^var','','')
        let l:currentWord = substitute(l:currentWord,'\(\w\+\)\$','\1\\$','g') " escape embeddend dollars in var name (e.g. TMP_$STOPM)
        call s:KnopVerboseEcho([l:currentWord,"appear to be a user defined VARIABLE"])
        return s:KrlSearchVar(l:declPrefix,l:currentWord)
        "
      elseif l:currentWord =~ '\v^(sys)?(proc|func)'
        let l:type = "DEF"
        if l:currentWord =~ '^sys'
          let l:type = "KSS " . l:type
        endif
        if l:currentWord =~ '^\v(sys)?func'
          let l:type = l:type . "FCT"
        endif
        let l:currentWord = substitute(l:currentWord,'\v^%(sys)?%(proc|func)','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a ".l:type])
        return s:KrlSearchProc(l:currentWord)
        "
      elseif l:currentWord =~ '^inst.*'
        let l:currentWord = substitute(l:currentWord,'^inst','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a KRL KEYWORD. Maybe a Struc or Enum."])
        return s:KrlSearchVar(l:declPrefix,l:currentWord)
        "
      elseif l:currentWord =~ '^enumval.*'
        let l:currentWord = substitute(l:currentWord,'^enumval','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be an ENUM VALUE."],1)
        return s:KrlSearchEnumVal('\v\c^\s*(global\s+)?enum\s+\w+\s+[0-9a-zA-Z_, \t]*',substitute(l:currentWord,'^#','',''))
        "
      elseif l:currentWord =~ '^header.*'
        let l:currentWord = substitute(l:currentWord,'^header','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a HEADER. No search performed."],1)
      elseif l:currentWord =~ '^num.*'
        let l:currentWord = substitute(l:currentWord,'^num','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a NUMBER. No search performed."],1)
      elseif l:currentWord =~ '^bool.*'
        let l:currentWord = substitute(l:currentWord,'^bool','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a BOOLEAN VALUE. No search performed."],1)
      elseif l:currentWord =~ '^string.*'
        let l:currentWord = substitute(l:currentWord,'^string','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a STRING. No search performed."],1)
      elseif l:currentWord =~ '^comment.*'
        let l:currentWord = substitute(l:currentWord,'^comment','','')
        if krl#IsVkrc() 
          if (l:currentWord=~'\cup\d\+' || l:currentWord=~'\cspsmakro\d\+' || l:currentWord=~'\cfolge\d\+')
            call s:KnopVerboseEcho([l:currentWord,"appear to be a VKRC CALL."])
            let l:currentWord = substitute(l:currentWord,'\c^spsmakro','makro','')
            return s:KrlSearchProc(l:currentWord)
          elseif l:currentWord =~ '\c\<m\d\+\>'
            call s:KnopVerboseEcho([l:currentWord,"appear to be a VKRC MARKER."])
            return s:KrlSearchVkrcMarker(l:currentWord)
          elseif l:currentWord =~ '\c\<bin\(in\)\?\d\+\>'
            call s:KnopVerboseEcho([l:currentWord,"appear to be a VKRC binary signal."])
            return s:KrlSearchVkrcBin(l:currentWord)
          endif
        endif
        call s:KnopVerboseEcho([l:currentWord,"appear to be a COMMENT. No search performed."],1)
      else
        let l:currentWord = substitute(l:currentWord,'^none','','')
        call s:KnopVerboseEcho([l:currentWord,"Could not determine typ of current word. No search performed."],1)
      endif
      return -1
      "
    endif
    "
    call s:KnopVerboseEcho("Unable to determine what to search for at current cursor position. No search performed.",1)
    return -1
    "
  endfunction " <SID>KrlGoDefinition()

  " }}} Go Definition

  " Auto Form {{{

  function s:KrlGetGlobal(sAction) abort
    if a:sAction=~'^[lg]'
      let l:sGlobal = a:sAction
    else
      let l:sGlobal = substitute(input("\n[g]lobal or [l]ocal?\n> "),'\W*','','g')
    endif
    if l:sGlobal=~'\c^\s*g'
      return "global "
    elseif l:sGlobal=~'\c^\s*l'
      return "local"
    endif
    return ''
  endfunction " s:KrlGetGlobal()

  function s:KrlGetType(sAction) abort
    if a:sAction =~ '^.[adf]'
      let l:sType = substitute(a:sAction,'^.\(\w\).','\1','')
    else
      let l:sType = substitute(input("\n[d]ef, def[f]ct or defd[a]t? \n> "),'\W*','','g')
    endif
    if l:sType =~ '\c^\s*d'
      return "def"
    elseif l:sType =~ '\c^\s*f'
      return "deffct"
    elseif l:sType =~ '\c^\s*a'
      return "defdat"
    endif
    return ''
  endfunction " s:KrlGetType()

  function s:KrlGetNameAndOpenFile(suffix) abort
    let l:sFilename = fnameescape(bufname("%"))
    let l:sName = substitute(input("\nName?\n Type %<enter> to use the current file name,\n or <space><enter> for word under cursor.\n> "),'[^ 0-9a-zA-Z_%]*','','g')
    if l:sName==""
      return ''
      "
    elseif l:sName=~'^%$' " sName from current file name
      let l:sName = substitute(l:sFilename,'\v^.*(<\$?\w+)\.\w\w\w$','\1','')
    elseif l:sName=~'^ $' " sName from current word
      let l:sName = expand("<cword>")
    endif
    let l:sName = substitute(l:sName,'[^0-9a-zA-Z_$]*','','g')
    if substitute(l:sFilename,'^.*\.\(\w\w\w\)$','\1','') !~ a:suffix
      let l:suffix = substitute(a:suffix,'\\c\\v(src|sub)','src','')
      let l:sFilename = substitute(l:sFilename,'\v^(.*)<\$?\w+\.\w\w\w$','\1'.l:sName.'.'.l:suffix,'')
    endif
    if fnameescape(bufname("%"))!=l:sFilename
      if filereadable(glob(l:sFilename))
        call s:KnopVerboseEcho("\nFile does already exists! Use\n :edit ".l:sFilename,1)
        return ''
        "
      elseif &mod && !&hid
        call s:KnopVerboseEcho("\nWrite current buffer first!",1)
        return ''
        "
      endif
      execute "edit ".l:sFilename
      set fileformat=dos
      setf krl
    endif
    return l:sName
  endfunction " s:KrlGetNameAndOpenFile()

  function s:KrlGetDataType(sAction) abort
    if a:sAction=~'..[abcfiprx6]'
      let l:sDataType = substitute(a:sAction,'..\(\w\)','\1','')
    else
      let l:sDataType = substitute(input("\nData type? \n
            \Choose [b]ool, [i]nt, [r]eal, [c]har, [f]rame, [p]os, e[6]pos, [a]xis, e6a[x]is,\n
            \ or enter your desired data type\n> "),'[^ 0-9a-zA-Z_\[\],]*','','g')
    endif
    if l:sDataType=~'\c^b$'
      return "bool"
    elseif l:sDataType=~'\c^i$'
      return "int"
    elseif l:sDataType=~'\c^r$'
      return "real"
    elseif l:sDataType=~'\c^c$'
      return "char"
    elseif l:sDataType=~'\c^f$'
      return "frame"
    elseif l:sDataType=~'\c^p$'
      return "pos"
    elseif l:sDataType=~'\c^6$'
      return "e6pos"
    elseif l:sDataType=~'\c^a$'
      return "axis"
    elseif l:sDataType=~'\c^x$'
      return "e6axis"
    endif
    return substitute(l:sDataType,'[^0-9a-zA-Z_\[\],]*','','g')
  endfunction " s:KrlGetDataType()

  function s:KrlGetReturnVar(sDataType) abort
    if a:sDataType=~'\c^bool\>'
      return "bResult"
    elseif a:sDataType=~'\c^int\>'
      return "nResult"
    elseif a:sDataType=~'\c^real\>'
      return "rResult"
    elseif a:sDataType=~'\c^char\>'
      return "cResult"
    elseif a:sDataType=~'\c^frame\>'
      return "fResult"
    elseif a:sDataType=~'\c^pos\>'
      return "pResult"
    elseif a:sDataType=~'\c^e6pos\>'
      return "e6pResult"
    elseif a:sDataType=~'\c^axis\>'
      return "aResult"
    elseif a:sDataType=~'\c^e6axis\>'
      return "e6aResult"
    endif
    return substitute(a:sDataType,'^\(..\).*','\l\1','')."Result"
  endfunction " s:KrlGetReturnVar()

  function s:KrlPositionForEdit() abort
    if !exists("g:krlPositionSet") | let g:krlPositionSet = 0 | endif
    if g:krlPositionSet==1 | return | endif
    let l:startline = getline('.')
    let l:startlinenum = line('.')
    let l:defline = '\c\v^\s*(global\s+)?def(fct|dat)?>'
    let l:enddefline = '\c\v^\s*end(fct|dat)?>'
    let l:emptyline = '^\s*$'
    let l:commentline = '^\s*;'
    let l:headerline = '^\s*&'
    if l:startline=~l:headerline && l:startlinenum!=line('$')
      " start on &header
      while getline('.')=~l:headerline && line('.')!=line('$')
        call s:KnopVerboseEcho("shift down because of &header")
        normal! j
      endwhile
      if line('.')==line('$')
            \&& getline('.')=~l:headerline
        normal! o
        call s:KnopVerboseEcho("started after header")
        "
        let g:krlPositionSet = 1
        return
        "
      elseif getline('.')=~l:emptyline
        if getline(line('.')+1)!=l:emptyline
          normal! O
        endif
        call s:KnopVerboseEcho("started after header")
        "
        let g:krlPositionSet = 1
        return
        "
      endif
      call s:KrlPositionForEdit()
      return
    elseif l:startline=~l:defline
      " start on def
      let l:prevline = getline(line('.')-1)
      while l:prevline=~l:commentline
        normal! k
        let l:prevline = getline(line('.')-1)
      endwhile
      normal! O
      if l:prevline=~l:headerline
        normal! O
      elseif l:prevline!~l:emptyline
        normal! o
      endif
      if getline(line('.')+1)!~l:emptyline
        normal! O
      endif
      call s:KnopVerboseEcho("started before def line")
      "
      let g:krlPositionSet = 1
      return
      "
    elseif l:startline=~l:enddefline
      " start on end
      normal! o
      normal! o
      if getline(line('.')+1)!~l:emptyline
        normal! O
      endif
      call s:KnopVerboseEcho("started after enddef line")
      "
      let g:krlPositionSet = 1
      return
      "
    elseif l:startlinenum==1
      " start on line 1
      if search(l:defline,'cW')
        call s:KnopVerboseEcho("found first def")
        call s:KrlPositionForEdit()
        return
      endif
      if l:startline!~l:emptyline
        normal! O
      endif
      if getline(line('.')+1)!~l:emptyline
        normal! O
      endif
      call s:KnopVerboseEcho("started at line 1")
      "
      let g:krlPositionSet = 1
      return
      "
    elseif l:startlinenum==line('$')
      " start on line $
      let l:prevline = getline(line('.')-1)
      if !(l:startlinenum=~l:emptyline && l:prevline=~l:emptyline)
        normal! o
      endif
      if getline(line('.')-1)!~l:emptyline
        normal! o
      endif
      call s:KnopVerboseEcho("started at line $")
      "
      let g:krlPositionSet = 1
      return
      "
    else
      " start in between
      if search(l:defline,'bcW')
        call search(l:enddefline,'cW')
        call s:KnopVerboseEcho("found enddef line between")
        call s:KrlPositionForEdit()
        return
      elseif search(l:enddefline,'cW')
        call s:KnopVerboseEcho("found enddef line between")
        call s:KrlPositionForEdit()
        return
      else
        " failsafe append to file
        normal! G
        normal! o
        normal! o
        call s:KnopVerboseEcho("failsafe append")
        "
        let g:krlPositionSet = 1
        return
        "
      endif
    endif
  endfunction " s:KrlPositionForEdit()

  function s:KrlPositionForEditWrapper() abort
    if exists("g:krlPositionSet")
      unlet g:krlPositionSet
    endif
    call s:KrlPositionForEdit()
    unlet g:krlPositionSet
    call s:KnopVerboseEcho("KrlPositionForEdit finished",1)
  endfunction " s:KrlPositionForEditWrapper()

  function s:KrlPositionForRead() abort
    call s:KrlPositionForEditWrapper()
    if getline('.')=~'^\s*$'
          \&& line('.')!=line('$')
      delete
    endif
  endfunction " s:KrlPositionForRead()

  function s:KrlReadBody(sBodyFile,sType,sName,sGlobal,sDataType,sReturnVar) abort
    let l:sBodyFile = glob(fnameescape(g:krlPathToBodyFiles)).a:sBodyFile
    " if !filereadable(glob(l:sBodyFile))
    if !filereadable(l:sBodyFile)
      call s:KnopVerboseEcho([l:sBodyFile,": Body file not readable."])
      return
    endif
    " read body
    call s:KrlPositionForRead()
    execute "silent .-1read ".glob(l:sBodyFile)
    " set marks
    let l:start = line('.')
    let l:end = search('\v\c^\s*end(fct|dat)?>','cnW')
    " substitute marks in body
    call s:KnopSubStartToEnd('<name>',a:sName,l:start,l:end)
    call s:KnopSubStartToEnd('<type>',a:sType,l:start,l:end)
    call s:KnopSubStartToEnd('<\%(global\|public\)>',a:sGlobal,l:start,l:end)
    " set another mark after the def(fct|dat)? line is present
    let l:defstart = search('\v\c^\s*(global\s+)?def(fct|dat)?>','cnW')
    call s:KnopSubStartToEnd('<datatype>',a:sDataType,l:start,l:defstart)
    call s:KnopSubStartToEnd('<returnvar>',a:sReturnVar,l:start,l:defstart)
    " correct array
    let l:sDataType = substitute(a:sDataType,'\[.*','','')
    let l:sReturnVar = a:sReturnVar . "<>" . a:sDataType
    let l:sReturnVar = substitute(l:sReturnVar,'<>\w\+\(\[.*\)\?','\1','')
    call s:KnopSubStartToEnd('<datatype>',l:sDataType,l:defstart+1,l:end)
    call s:KnopSubStartToEnd('<returnvar>',l:sReturnVar,l:defstart+1,l:end)
    call s:KnopSubStartToEnd('\v(^\s*return\s+\w+\[)\d+(,)?\d*(,)?\d*(\])','\1\2\3\4',l:defstart+1,l:end)
    " upper case?
    if get(g:,'krlAutoFormUpperCase',0)
      call s:KnopUpperCase(l:defstart,l:end)
    endif
    " indent
    if exists("b:did_indent")
      if l:start>0 && l:end>l:start
        execute l:start.','.l:end."substitute/^/ /"
        call cursor(l:start,0)
        execute "silent normal! " . (l:end-l:start+1) . "=="
      endif
    endif
    " position cursor
    call cursor(l:start,0)
    if search('<|>','cW',l:end)
      call setline('.',substitute(getline('.'),'<|>','','g'))
    endif
  endfunction " s:KrlReadBody()

  function s:KrlDefaultDefdatBody(sName,sGlobal) abort
    call s:KrlPositionForEditWrapper()
    call setline('.',"defdat ".a:sName.a:sGlobal)
    normal! o
    call setline('.',";")
    normal! o
    call setline('.',"enddat")
    call search('\c^\s*defdat ','bW')
    if exists("b:did_indent")
      execute ",+2substitute/^/ /"
      silent normal! 2k3==
    endif
    if get(g:,'krlAutoFormUpperCase',0)
      call s:KnopUpperCase(line('.'),search('\v\c^\s*enddat>','cnW'))
    endif
    call search(';','W')
    return
  endfunction " s:KrlDefaultDefdatBody()

  function s:KrlDefaultDefBody(sName,sGlobal) abort
    call s:KrlPositionForEditWrapper()
    let l:sGlobal = a:sGlobal
    if line(".")==1 | let l:sGlobal = '' | endif " assume this is the first def in this file, no global needed
    call setline('.',l:sGlobal."def ".a:sName.'()')
    normal! o
    call setline('.',";")
    normal! o
    call setline('.',"end ; ".a:sName."()")
    call search('\v\c^\s*(global )?def ','bW')
    if exists("b:did_indent")
      execute ",+2substitute/^/ /"
      silent normal! 2k3==
    endif
    if get(g:,'krlAutoFormUpperCase',0)
      call s:KnopUpperCase(line('.'),search('\v\c^\s*end>','cnW'))
    endif
    call search(';','W')
  endfunction " s:KrlDefaultDefBody()

  function s:KrlDefaultDeffctBody(sName,sGlobal,sDataType,sReturnVar) abort
    call s:KrlPositionForEditWrapper()
    let l:sGlobal = a:sGlobal
    if line(".")==1 | let l:sGlobal = '' | endif " assume this is the first def in this file, no global needed
    call setline('.',l:sGlobal."deffct ".a:sDataType." ".a:sName.'()')
    normal! o
    call setline('.',"decl ".a:sDataType." ".a:sReturnVar)
    let l:sReturnVar = a:sReturnVar
    if getline('.') =~ '\]'
      " correct the decl line in case of array function
      s/\(^\s*\w\+\s\+\w\+\)\(\[[0-9,]\+\]\)\(\s\+\w\+\)/\1\3\2/g
      let l:sReturnVar = substitute(getline('.'),'^\s*\w\+\s\+\w\+\s\+\(\w\+\[[0-9,]\+\]\)','\1','')
      let l:sReturnVar = substitute(l:sReturnVar,'\v(\[)\d*(,)?\d*(,)?\d*(\])','\1\2\3\4','g')
    endif
    normal! o
    call setline('.',";")
    normal! o
    call setline('.',"return ".l:sReturnVar)
    normal! o
    call setline('.',"endfct ; ".a:sName."()")
    call search('\v\c^\s*(global )?deffct ','bW')
    if exists("b:did_indent")
      execute ",+4substitute/^/ /"
      silent normal! 4k5==
    endif
    if get(g:,'krlAutoFormUpperCase',0)
      call s:KnopUpperCase(line('.'),search('\v\c^\s*endfct>','cnW'))
    endif
    call search(')','cW')
    return
  endfunction " s:KrlDefaultDeffctBody()

  function <SID>KrlAutoForm(sAction) abort
    " check input
    if a:sAction !~ '^[ lg][ adf][ abcfiprx6]$' | return | endif
    "
    let l:sGlobal = s:KrlGetGlobal(a:sAction)
    if l:sGlobal == '' | return | endif " return if empty string was entered by user
    let l:sGlobal = substitute(l:sGlobal,'local','','g')
    "
    " get def, deffct or defdat
    let l:sType = s:KrlGetType(a:sAction)
    if l:sType == '' | return | endif " return if empty string was entered by user
    "
    if l:sType =~ '^defdat\>'
      "
      let l:sName = s:KrlGetNameAndOpenFile('dat')
      if l:sName == '' | return | endif
      let l:sGlobal = substitute(l:sGlobal,'global ',' public','')
      if exists("g:krlPathToBodyFiles") && filereadable(glob(fnameescape(g:krlPathToBodyFiles)).'defdat.dat')
        call s:KnopVerboseEcho("\nBody file will be used")
        call s:KnopVerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'defdat.dat',1)
        call s:KrlReadBody('defdat.dat',l:sType,l:sName,l:sGlobal,'','')
      else
        if exists("g:krlPathToBodyFiles")
          call s:KnopVerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'defdat.dat')
          call s:KnopVerboseEcho(" is not readable!")
        endif
        call s:KnopVerboseEcho("\nDefault body will be used",1)
        call s:KrlDefaultDefdatBody(l:sName,l:sGlobal)
      endif
      "
    elseif l:sType =~ '^def\>'
      "
      let l:sName = s:KrlGetNameAndOpenFile('\c\v(src|sub)')
      if l:sName == '' | return | endif
      if exists("g:krlPathToBodyFiles") && filereadable(glob(fnameescape(g:krlPathToBodyFiles)).'def.src')
        call s:KnopVerboseEcho("\nBody file will be used")
        call s:KnopVerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'def.src',1)
        call s:KrlReadBody('def.src',l:sType,l:sName,l:sGlobal,'','')
      else
        if exists("g:krlPathToBodyFiles")
          call s:KnopVerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'def.src')
          call s:KnopVerboseEcho(" is not readable!")
        endif
        call s:KnopVerboseEcho("\nDefault body will be used",1)
        call s:KrlDefaultDefBody(l:sName,l:sGlobal)
      endif
      "
    elseif l:sType =~ '^deffct\>'
      "
      let l:sDataType = s:KrlGetDataType(a:sAction)
      if l:sDataType == '' | return | endif
      let l:sReturnVar = s:KrlGetReturnVar(l:sDataType)
      let l:sName = s:KrlGetNameAndOpenFile('\c\v(src|sub)')
      if l:sName == '' | return | endif
      if exists("g:krlPathToBodyFiles") && filereadable(glob(fnameescape(g:krlPathToBodyFiles)).'deffct.src')
        call s:KnopVerboseEcho("\nBody file will be used")
        call s:KnopVerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'deffct.src',1)
        call s:KrlReadBody('deffct.src',l:sType,l:sName,l:sGlobal,l:sDataType,l:sReturnVar)
      else
        if exists("g:krlPathToBodyFiles")
          call s:KnopVerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'deffct.src')
          call s:KnopVerboseEcho(" is not readable!")
        endif
        call s:KnopVerboseEcho("\nDefault body will be used",1)
        call s:KrlDefaultDeffctBody(l:sName,l:sGlobal,l:sDataType,l:sReturnVar)
      endif
      "
    else
      return
    endif
    "
    normal! zz
    silent doautocmd User KrlAutoFormPost
    "
  endfunction " <SID>KrlAutoForm()

  " }}} Auto Form

  " List Def/Usage {{{

  function <SID>KrlListDefinition() abort
    " list defs in qf
    if s:KnopSearchPathForPatternNTimes('\v\c^\s*(global\s+)?def(fct)?>','%','','krl')==0
      call setqflist([], ' ', {'items' : getqflist(), 'quickfixtextfunc' : 'KnopEraseQFPaths', 'nr': "$"})
      call s:KnopOpenQf('krl',"don't format'")
    else
      call s:KnopVerboseEcho("Nothing found.",1)
    endif
  endfunction " <SID>KrlListDefinition()

  function <SID>KrlListUsage() abort
    "
    if search('\w','cW',line("."))
      let l:currentWord = s:KrlCurrentWordIs()
      let l:type = ''
      "
      if l:currentWord =~ '^sysvar.*'
        let l:type = 'SYSVAR'
        let l:currentWord = substitute(l:currentWord,'^sysvar','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a KSS VARIABLE"])
        let l:currentWord = substitute(l:currentWord,'\$','\\$','g') " escape any dollars in var name
      elseif l:currentWord =~ '^header.*'
        let l:type = 'HEADER'
        let l:currentWord = substitute(l:currentWord,'^header','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a HEADER."])
        let l:currentWord = substitute(l:currentWord,'&','\\&','g') " escape any & in var name
      elseif l:currentWord =~ '^var.*'
        let l:type = 'USERVAR'
        let l:currentWord = substitute(l:currentWord,'^var','','')
        let l:currentWord = substitute(l:currentWord,'\$','\\$','g') " escape embeddend dollars in var name (e.g. TMP_$STOPM)
        call s:KnopVerboseEcho([l:currentWord,"appear to be a user defined VARIABLE"])
      elseif l:currentWord =~ '\v^%(sys)?%(proc|func)'
        let l:type = 'DEF'
        if l:currentWord =~ '^sys'
          let l:type = 'KSS ' . l:type
        endif
        if l:currentWord =~ '^\v%(sys)?func'
          let l:type = l:type . 'FCT'
        endif
        let l:currentWord = substitute(l:currentWord,'\v^%(sys)?%(proc|func)','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a ".l:type])
      elseif l:currentWord =~ '^enumval.*'
        let l:type = 'ENUMVALUE'
        let l:currentWord = substitute(l:currentWord,'^enumval','','')
        let l:currentWord = substitute(l:currentWord,'\v(#)(\w+)','(\1\2|(decl\\s+)?(global\\s+)?enum\\s+\\w+\\s+[0-9a-zA-Z_, \t]*\2)','') " search also without # to find the declaration
        call s:KnopVerboseEcho([l:currentWord,"appear to be an ENUM VALUE."])
      elseif l:currentWord =~ '^num.*'
        let l:type = 'NUMERIC'
        let l:currentWord = substitute(l:currentWord,'^num','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a NUMBER."])
      elseif l:currentWord =~ '^string.*'
        let l:type = 'STRING'
        let l:currentWord = substitute(l:currentWord,'^string','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a STRING."])
      elseif l:currentWord =~ '^comment.*'
        let l:type = 'COMMENT'
        let l:currentWord = substitute(l:currentWord,'^comment','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a COMMENT."])
      elseif l:currentWord =~ '^inst.*'
        let l:type = 'INSTRUCTION'
        let l:currentWord = substitute(l:currentWord,'^inst','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a KRL KEYWORD."])
      elseif l:currentWord =~ '^bool.*'
        let l:type = 'BOOL'
        let l:currentWord = substitute(l:currentWord,'^bool','','')
        call s:KnopVerboseEcho([l:currentWord,"appear to be a BOOL VALUE."])
      else
        let l:type = 'NONE'
        let l:currentWord = substitute(l:currentWord,'^none','','')
        call s:KnopVerboseEcho([l:currentWord,"Unable to determine what to search for at current cursor position. No search performed!"],1)
        return
        "
      endif
      call s:KrlAlterIsKeyWord(1)
      let l:nonecomment = ''
      if !krl#IsVkrc()
        let l:nonecomment = '^[^;]*'
      endif
      if s:KnopSearchPathForPatternNTimes('\c\v'.l:nonecomment.'<'.l:currentWord.'>',s:KnopPreparePath(&path,'*.[sS][rR][cC]').' '.s:KnopPreparePath(&path,'*.[sS][uU][bB]').' '.s:KnopPreparePath(&path,'*.[dD][aA][tT]').' ','','krl')==0
        call setqflist(s:KnopUniqueListItems(getqflist()))
        " rule out ENUM declaration if not looking for ENUM values
        let l:qftmp1 = []
        if l:type != 'ENUMVALUE'
          for l:i in getqflist()
            if get(l:i,'text') !~ '\v\c^\s*(global\s+)?enum>'
              call add(l:qftmp1,l:i)
            endif
          endfor
        else
          let l:qftmp1 = getqflist()
        endif
        " rule out if l:currentWord appear after &header
        let l:qftmp2 = []
        for l:i in l:qftmp1
          if get(l:i,'text') !~ '\v\c^\s*\&.*'.l:currentWord
            call add(l:qftmp2,l:i)
          endif
        endfor
        " rule out l:currentWord inside a backup file
        let l:qfresult = []
        for l:i in l:qftmp2
          if bufname(get(l:i,'bufnr')) !~ '\~$'
        "         \&& (get(l:i,'text') =~ '\v\c^([^"]*"[^"]*"[^"]*)*[^"]*<'.l:currentWord.'>'
            call add(l:qfresult,l:i)
          endif
        endfor
        call setqflist(l:qfresult)
        call s:KnopVerboseEcho("Opening quickfix with results.",1)
        call s:KnopOpenQf('krl')
      else
        call s:KnopVerboseEcho("Nothing found.",1)
      endif
      call s:KrlResetIsKeyWord()
    else
      call s:KnopVerboseEcho("Unable to determine what to search for at current cursor position. No search performed.",1)
    endif
  endfunction " <SID>KrlListUsage()

  " }}} List Def/Usage

endif " !exists("*s:KnopVerboseEcho()")

" Vim Settings {{{

" path for gf, :find etc
if get(g:,'krlPath',1)

  let s:pathcurrfile = s:KnopFnameescape4Path(substitute(expand("%:p:h"), '\\', '/', 'g'))
  if s:pathcurrfile =~ '\v\c\/krc%(\/[^/]+){,5}$'
    " KRC found. Use that one
    let s:krlpath=substitute(s:pathcurrfile, '\c\v(\/krc)\/%(%(<krc>)@!.)*$', '\1/**,' ,'g')
  elseif s:pathcurrfile =~ '\v\c\/r1%(\/[^/]+){,4}$'
        \&& (     s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Mada',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Program',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/System',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/TP',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Folgen',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Makros',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/UPs',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/VW_User',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,   '\c\v(\/MaDa)%(\/r1)\/%(%(<r1>)@!.)*$','\1',''))
        \     ||  s:KnopDirExists(substitute(s:pathcurrfile,'\c\v(\/PowerOn)%(\/r1)\/%(%(<r1>)@!.)*$','\1',''))
        \    )
    if s:pathcurrfile =~ '\c\v\/MaDa\/R1$'
      " krc1 MaDa/R1/ found, search for PowerOn as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/MaDa)\/R1$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cMaDa$', 'PowerOn' ,'')
      if s:KnopDirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    elseif s:pathcurrfile =~ '\c\v\/PowerOn\/R1$'
      " krc1 PowerOn/R1/ found, search for MaDa as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/PowerOn)\/R1$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cPowerOn$', 'MaDa' ,'')
      if s:KnopDirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    else
      " > krc1 R1 found, search for STEU as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/R1)\/%(%(<R1>)@!.)*$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cR1$', 'STEU' ,'')
      if s:KnopDirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    endif
  elseif s:pathcurrfile =~ '\v\c\/Steu%(\/[^/]+){,1}$'
    if s:pathcurrfile =~ '\c\v\/MaDa\/Steu$'
      " krc1 MaDa/Steu/ found, search for PowerOn as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/MaDa)\/Steu$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cMaDa$', 'PowerOn' ,'')
      if s:KnopDirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    elseif s:pathcurrfile =~ '\c\v\/PowerOn\/Steu$'
      " krc1 PowerOn/Steu/ found, search for MaDa as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/PowerOn)\/Steu$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cPowerOn$', 'MaDa' ,'')
      if s:KnopDirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    else
      " > krc1 STEU found, search for R1 as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/Steu)\/%(%(<Steu>)@!.)*$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cSteu$', 'R1' ,'')
      if s:KnopDirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    endif
  elseif s:pathcurrfile =~ '\v\c\/%(Mada|Program|System|TP|Folgen|Makros|UPs|VW_User)%(\/[^/]+){,3}$'
    let s:pathcurrfile = substitute(s:pathcurrfile, '\v\c\/%(Mada|Program|System|TP|Folgen|Makros|UPs|VW_User)%(\/[^/]+){,3}$', '' ,'g')
    let s:krlpath=s:pathcurrfile. '/**,'
  else
    " ACHTUNG: behalte die problematik im Auge das . der Pfad zur aktuellen
    " Datei ist, und nicht das aktuelle working directory!
    let s:krlpath='./**'
  endif

  call s:KnopVerboseEcho("'path' set to: " . s:krlpath)
  execute "setlocal path=".s:krlpath
  let b:undo_ftplugin = b:undo_ftplugin." pa<"

endif " get(g:,'krlPath',1)

" complete
let s:pathList = s:KnopSplitAndUnescapeCommaSeparatedPathStr(&path)
let s:pathToCurrentFile = substitute(expand("%:p:h"),'\\','/','g')
"
" complete custom files
if exists('g:krlCompleteCustom')
  for s:customCompleteAdditions in g:krlCompleteCustom
    let s:file = substitute(s:customCompleteAdditions,'^.*[\\/]\(\$?\w\+\.\)\(\w\+\)$','\1\2','')
    call s:KnopAddFileToCompleteOption(s:customCompleteAdditions,s:pathList,s:pathToCurrentFile.'/'.s:file,)
  endfor
endif
"
" complete standard files
if get(g:,'krlCompleteStd',1)
  "
  " <filename>.dat
  if expand("%:p:t") !~ '\c\.dat$'
    call s:KnopAddFileToCompleteOption(substitute(expand("%:p:t"),'\c\.s\%(rc\|ub\)$','.dat',''),[s:pathToCurrentFile])
  endif
  " R1/System/$config.dat
  call s:KnopAddFileToCompleteOption('R1/System/$config.dat',s:pathList,s:pathToCurrentFile.'/'.'$config.dat')
  " R1/System/Global_Points.dat
  call s:KnopAddFileToCompleteOption('R1/System/Global_Points.dat',s:pathList,s:pathToCurrentFile.'/'.'Global_Points.dat')
  " R1/System/MsgLib.src
  call s:KnopAddFileToCompleteOption('R1/System/MsgLib.src',s:pathList,s:pathToCurrentFile.'/'.'MsgLib.src')
  " R1/Mada/$machine.dat
  call s:KnopAddFileToCompleteOption('R1/Mada/$machine.dat',s:pathList,s:pathToCurrentFile.'/'.'$machine.dat')
  " R1/Mada/$robcor.dat
  call s:KnopAddFileToCompleteOption('R1/Mada/$robcor.dat',s:pathList,s:pathToCurrentFile.'/'.'$robcor.dat')
  " STEU/Mada/$custom.dat
  call s:KnopAddFileToCompleteOption('Steu/Mada/$custom.dat',s:pathList,s:pathToCurrentFile.'/'.'$custom.dat')
  " STEU/Mada/$machine.dat
  call s:KnopAddFileToCompleteOption('Steu/Mada/$machine.dat',s:pathList)
  " STEU/Mada/$option.dat
  call s:KnopAddFileToCompleteOption('Steu/Mada/$option.dat',s:pathList,s:pathToCurrentFile.'/'.'$option.dat')
  " TP/Signals.dat
  call s:KnopAddFileToCompleteOption('R1/TP/Signals.dat',s:pathList,s:pathToCurrentFile.'/'.'Signals.dat')
  "
  " syntax file
  let s:pathList=[]
  for s:i in split(&rtp,'\\\@1<!,')
    call add(s:pathList,substitute(s:i,'\\','/','g')) 
  endfor
  call s:KnopAddFileToCompleteOption('syntax/krl.vim',s:pathList)
  if exists("g:knopCompleteMsg2")|unlet g:knopCompleteMsg2|endif
  "
  let b:undo_ftplugin = b:undo_ftplugin." cpt<"
endif " get(g:,'krlCompleteStd',1)
unlet s:pathList
unlet s:pathToCurrentFile

" }}} Vim Settings

" Other configurable key mappings {{{

if get(g:,'krlGoDefinitionKeyMap',0) 
      \|| mapcheck("gd","n")=="" && !hasmapto('<plug>KrlGoDef','n')
  " Go Definition
  nmap <silent><buffer> gd <plug>KrlGoDef
endif
if get(g:,'krlListDefKeyMap',0)
      \|| mapcheck("<leader>f","n")=="" && !hasmapto('<plug>KrlListDef','n')
  " list all DEFs of current file
  nmap <silent><buffer> <leader>f <plug>KrlListDef
endif
if get(g:,'krlListUsageKeyMap',0)
      \|| mapcheck("<leader>u","n")=="" && !hasmapto('<plug>KrlListUse','n')
  " list all uses of word under cursor
  nmap <silent><buffer> <leader>u <plug>KrlListUse
endif

if get(g:,'krlAutoFormKeyMap',0)
      \|| mapcheck("<leader>n","n")=="" && !hasmapto('<plug>KrlAutoForm','n')
  nnoremap <silent><buffer> <leader>n     :call <SID>KrlAutoForm("   ")<cr>
  nnoremap <silent><buffer> <leader>nn    :call <SID>KrlAutoForm("   ")<cr>
  "
  nnoremap <silent><buffer> <leader>nl    :call <SID>KrlAutoForm("l  ")<cr>
  nnoremap <silent><buffer> <leader>nll   :call <SID>KrlAutoForm("l  ")<cr>
  "
  nnoremap <silent><buffer> <leader>nla   :call <SID>KrlAutoForm("la ")<cr>
  nnoremap <silent><buffer> <leader>nld   :call <SID>KrlAutoForm("ld ")<cr>
  nnoremap <silent><buffer> <leader>nlf   :call <SID>KrlAutoForm("lf ")<cr>
  nnoremap <silent><buffer> <leader>nlfu  :call <SID>KrlAutoForm("lf ")<cr>
  "
  nnoremap <silent><buffer> <leader>nlfa  :call <SID>KrlAutoForm("lfa")<cr>
  nnoremap <silent><buffer> <leader>nlfb  :call <SID>KrlAutoForm("lfb")<cr>
  nnoremap <silent><buffer> <leader>nlfc  :call <SID>KrlAutoForm("lfc")<cr>
  nnoremap <silent><buffer> <leader>nlff  :call <SID>KrlAutoForm("lff")<cr>
  nnoremap <silent><buffer> <leader>nlfi  :call <SID>KrlAutoForm("lfi")<cr>
  nnoremap <silent><buffer> <leader>nlfp  :call <SID>KrlAutoForm("lfp")<cr>
  nnoremap <silent><buffer> <leader>nlfr  :call <SID>KrlAutoForm("lfr")<cr>
  nnoremap <silent><buffer> <leader>nlfx  :call <SID>KrlAutoForm("lfx")<cr>
  nnoremap <silent><buffer> <leader>nlf6  :call <SID>KrlAutoForm("lf6")<cr>
  "
  nnoremap <silent><buffer> <leader>na    :call <SID>KrlAutoForm("la ")<cr>
  nnoremap <silent><buffer> <leader>nd    :call <SID>KrlAutoForm("ld ")<cr>
  nnoremap <silent><buffer> <leader>nf    :call <SID>KrlAutoForm("lf ")<cr>
  nnoremap <silent><buffer> <leader>nfu   :call <SID>KrlAutoForm("lf ")<cr>
  "
  nnoremap <silent><buffer> <leader>nfa   :call <SID>KrlAutoForm("lfa")<cr>
  nnoremap <silent><buffer> <leader>nfb   :call <SID>KrlAutoForm("lfb")<cr>
  nnoremap <silent><buffer> <leader>nfc   :call <SID>KrlAutoForm("lfc")<cr>
  nnoremap <silent><buffer> <leader>nff   :call <SID>KrlAutoForm("lff")<cr>
  nnoremap <silent><buffer> <leader>nfi   :call <SID>KrlAutoForm("lfi")<cr>
  nnoremap <silent><buffer> <leader>nfp   :call <SID>KrlAutoForm("lfp")<cr>
  nnoremap <silent><buffer> <leader>nfr   :call <SID>KrlAutoForm("lfr")<cr>
  nnoremap <silent><buffer> <leader>nfx   :call <SID>KrlAutoForm("lfx")<cr>
  nnoremap <silent><buffer> <leader>nf6   :call <SID>KrlAutoForm("lf6")<cr>
  "
  nnoremap <silent><buffer> <leader>ng    :call <SID>KrlAutoForm("g  ")<cr>
  nnoremap <silent><buffer> <leader>ngg   :call <SID>KrlAutoForm("g  ")<cr>
  "
  nnoremap <silent><buffer> <leader>nga   :call <SID>KrlAutoForm("ga ")<cr>
  nnoremap <silent><buffer> <leader>ngd   :call <SID>KrlAutoForm("gd ")<cr>
  nnoremap <silent><buffer> <leader>ngf   :call <SID>KrlAutoForm("gf ")<cr>
  nnoremap <silent><buffer> <leader>ngfu  :call <SID>KrlAutoForm("gf ")<cr>
  "
  nnoremap <silent><buffer> <leader>ngfa  :call <SID>KrlAutoForm("gfa")<cr>
  nnoremap <silent><buffer> <leader>ngfb  :call <SID>KrlAutoForm("gfb")<cr>
  nnoremap <silent><buffer> <leader>ngfc  :call <SID>KrlAutoForm("gfc")<cr>
  nnoremap <silent><buffer> <leader>ngff  :call <SID>KrlAutoForm("gff")<cr>
  nnoremap <silent><buffer> <leader>ngfi  :call <SID>KrlAutoForm("gfi")<cr>
  nnoremap <silent><buffer> <leader>ngfp  :call <SID>KrlAutoForm("gfp")<cr>
  nnoremap <silent><buffer> <leader>ngfr  :call <SID>KrlAutoForm("gfr")<cr>
  nnoremap <silent><buffer> <leader>ngfx  :call <SID>KrlAutoForm("gfx")<cr>
  nnoremap <silent><buffer> <leader>ngf6  :call <SID>KrlAutoForm("gf6")<cr>
endif " g:krlAutoFormKeyMap

" }}} Configurable mappings

" <PLUG> mappings {{{

" Go Definition
nnoremap <silent><buffer> <plug>KrlGoDef :call <SID>KrlGoDefinition()<CR>

" list all DEFs of current file
nnoremap <silent><buffer> <plug>KrlListDef :call <SID>KrlListDefinition()<CR>

" list usage
nnoremap <silent><buffer> <plug>KrlListUse :call <SID>KrlListUsage()<CR>

" auto form
nnoremap <silent><buffer> <plug>KrlAutoForm                 :call <SID>KrlAutoForm("   ")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalDat         :call <SID>KrlAutoForm("la ")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalDef         :call <SID>KrlAutoForm("ld ")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFct         :call <SID>KrlAutoForm("lf ")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctBool     :call <SID>KrlAutoForm("lfb")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctInt      :call <SID>KrlAutoForm("lfi")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctReal     :call <SID>KrlAutoForm("lfr")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctChar     :call <SID>KrlAutoForm("lfc")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctFrame    :call <SID>KrlAutoForm("lff")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctPos      :call <SID>KrlAutoForm("lfp")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctE6Pos    :call <SID>KrlAutoForm("lf6")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctAxis     :call <SID>KrlAutoForm("lfa")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormLocalFctE6Axis   :call <SID>KrlAutoForm("lfx")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalDat        :call <SID>KrlAutoForm("ga ")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalDef        :call <SID>KrlAutoForm("gd ")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFct        :call <SID>KrlAutoForm("gf ")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctBool    :call <SID>KrlAutoForm("gfb")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctInt     :call <SID>KrlAutoForm("gfi")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctReal    :call <SID>KrlAutoForm("gfr")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctChar    :call <SID>KrlAutoForm("gfc")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctFrame   :call <SID>KrlAutoForm("gff")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctPos     :call <SID>KrlAutoForm("gfp")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctE6Pos   :call <SID>KrlAutoForm("gf6")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctAxis    :call <SID>KrlAutoForm("gfa")<cr>
nnoremap <silent><buffer> <plug>KrlAutoFormGlobalFctE6Axis  :call <SID>KrlAutoForm("gfx")<cr>
" auto form end

" }}} <plug> mappings

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker
