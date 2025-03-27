" Vim file type plugin
" Language: Kuka Robot Language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 3.0.0
" Last Change: 27. Mar 2025
"

" Init {{{
let s:keepcpo = &cpo
set cpo&vim
" }}} init

" only declare functions once
if !exists("*s:KrlSearchVkrcMarker()")

  " Go Definition {{{

  function s:KrlSearchVkrcMarker(currentWord) abort
    call knop_extras#VerboseEcho("Search marker definitions...")
    let l:markerNumber = substitute(a:currentWord,'\cm','','')
    if (knop_extras#SearchPathForPatternNTimes('\c^\s*\$cycflag\s*\[\s*'.l:markerNumber.'\s*\]\s*=',knop_extras#PreparePath(&path,'*.[sS][rR][cC]').' '.knop_extras#PreparePath(&path,'*.[sS][uU][bB]'),'','krl') == 0)
      call setqflist(knop_extras#UniqueListItems(getqflist()))
      call knop_extras#OpenQf('krl')
      call knop_extras#VerboseEcho("Marker definition found.",1)
      return 0
    endif
    call knop_extras#VerboseEcho("Nothing found.",1)
    return -1
  endfunction

  function s:KrlSearchVkrcBin(currentWord) abort
    call knop_extras#VerboseEcho("Search binary signal definitions...")
    let l:binNumber = substitute(a:currentWord,'\cbin\(in\)\?','','')
    if a:currentWord=~?'binin'
      if (knop_extras#SearchPathForPatternNTimes('\v\c^\s*\$bin_in\[\s*'.l:binNumber.'\s*\]\s*\=',krl_extras#PathWithGlobalDataLists(),'1','krl') == 0)
        call knop_extras#OpenQf('krl')
        call knop_extras#VerboseEcho("BIN_IN found.",1)
        return 0
      endif
    else
      if (knop_extras#SearchPathForPatternNTimes('\v\c^\s*\$bin_out\[\s*'.l:binNumber.'\s*\]\s*\=',krl_extras#PathWithGlobalDataLists(),'1','krl') == 0)
        call knop_extras#OpenQf('krl')
        call knop_extras#VerboseEcho("BIN_OUT found.",1)
        return 0
      endif
    endif
    call knop_extras#VerboseEcho("Nothing found.",1)
    return -1
  endfunction

  function s:KrlSearchSysvar(declPrefix,currentWord) abort
    " a:currentWord starts with '$' so we need '\' at the end of declPrefix pattern
    call knop_extras#VerboseEcho("Search global data lists...")
    if (knop_extras#SearchPathForPatternNTimes(a:declPrefix.'\'.a:currentWord.">",krl_extras#PathWithGlobalDataLists(),'1','krl') == 0)
      call knop_extras#VerboseEcho("Found global data list declaration. The quickfix window will open. See :he quickfix-window",1)
      return 0
    endif
    call knop_extras#VerboseEcho("Nothing found.",1)
    return -1
  endfunction " s:KrlSearchSysvar()

  function s:KrlSearchEnumVal(declPrefix,currentWord) abort
    "
    let l:qf = []
    " search corrosponding dat file
    call knop_extras#VerboseEcho("Search local data list...")
    let l:filename = substitute(fnameescape(bufname("%")),'\c\.s[ur][bc]$','.[dD][aA][tT]','')
    if filereadable(glob(l:filename))
      if (knop_extras#SearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",l:filename,'','krl') == 0)
        call knop_extras#VerboseEcho("Found local data list declaration. The quickfix window will open. See :he quickfix-window",1)
        let l:qf = getqflist()
        "
      endif
    else
      call knop_extras#VerboseEcho(["File ",l:filename," not readable"])
    endif " search corrosponding dat file
    "
    " also search global data lists
    call knop_extras#VerboseEcho("Search global data lists...")
    if (knop_extras#SearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",krl_extras#PathWithGlobalDataLists(),'','krl') == 0)
      call knop_extras#VerboseEcho("Found global data list declaration. The quickfix window will open. See :he quickfix-window",1)
      let l:qf = l:qf + getqflist()
      "
    endif
    "
    if l:qf != []
      call setqflist(l:qf)
      if knop_extras#OpenQf('krl')==-1
        call knop_extras#VerboseEcho("No match found")
        return -1
      endif
      return 0
    endif
    "
    call knop_extras#VerboseEcho("Nothing found.",1)
    return -1
  endfunction

  function s:KrlSearchVar(declPrefix,currentWord) abort
    "
    " first search for local declartion
    call knop_extras#VerboseEcho("Search def(fct)? local declaration...")
    let l:numLine = line(".")
    let l:numCol = col(".")
    let l:numDefLine = search('\v\c^\s*(global\s+)?<def(fct|dat)?>','bW')
    let l:numEndLine = search('\v\c^\s*<end(fct|dat)?>','nW')
    if search(a:declPrefix.'\zs<'.a:currentWord.">","W",l:numEndLine)
      call knop_extras#VerboseEcho("Found def(fct|dat)? local declaration. Get back where you came from with ''",1)
      return 0
      "
    else
      call knop_extras#VerboseEcho("No match found")
      call cursor(l:numLine,l:numCol)
    endif
    "
    " second search corrosponding dat file
    call knop_extras#VerboseEcho("Search local data list...")
    let l:filename = substitute(fnameescape(bufname("%")),'\c\.s[ur][bc]$','.[dD][aA][tT]','')
    if filereadable(glob(l:filename))
      if (knop_extras#SearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",l:filename,'1','krl') == 0)
        call knop_extras#VerboseEcho("Found local data list declaration. The quickfix window will open. See :he quickfix-window",1)
        return 0
        "
      endif
    else
      call knop_extras#VerboseEcho(["File ",l:filename," not readable"])
    endif " search corrosponding dat file
    "
    " third search global data lists
    call knop_extras#VerboseEcho("Search global data lists...")
    if (knop_extras#SearchPathForPatternNTimes(a:declPrefix.'<'.a:currentWord.">",krl_extras#PathWithGlobalDataLists(),'1','krl') == 0)
      call knop_extras#VerboseEcho("Found global data list declaration. The quickfix window will open. See :he quickfix-window",1)
      return 0
      "
    endif
    "
    call knop_extras#VerboseEcho("Nothing found.",1)
    return -1
  endfunction " s:KrlSearchVar()

  function s:KrlSearchProc(currentWord) abort
    "
    " first search for local def(fct)? declartion
    call knop_extras#VerboseEcho("Search def(fct)? definitions in current file...")
    let l:numLine = line(".")
    let l:numCol = col(".")
    0
    if search('\c\v^\s*(global\s+)?def(fct\s+\w+(\[[0-9,]*\])?)?\s+\zs'.a:currentWord.'>','cw',"$")
      call knop_extras#VerboseEcho("Found def(fct)? local declaration. Get back where you came from with ''",1)
      return 0
      "
    else
      call knop_extras#VerboseEcho("No match found")
      call cursor(l:numLine,l:numCol)
    endif
    "
    " second search src file name = a:currentWord
    try
      let l:saved_fileignorecase = &fileignorecase
      setlocal fileignorecase
      call knop_extras#VerboseEcho("Search .src files in &path...")
      let l:path = knop_extras#PreparePath(&path,a:currentWord.'.[sS][rR][cC]').knop_extras#PreparePath(&path,a:currentWord.'.[sS][uU][bB]')
      if !filereadable('./'.a:currentWord.'.[sS][rR][cC]') " suppress message about missing file
        let l:path = substitute(l:path, '\.[\\/]'.a:currentWord.'.\[sS\]\[rR\]\[cC\] ', ' ','g')
      endif
      if !filereadable('./'.a:currentWord.'.[sS][uU][bB]') " suppress message about missing file
        let l:path = substitute(l:path, '\.[\\/]'.a:currentWord.'.\[sS\]\[uU\]\[bB\] ', ' ','g')
      endif
      if (knop_extras#SearchPathForPatternNTimes('\c\v^\s*(global\s+)?def(fct\s+\w+(\[[0-9,]*\])?)?\s+'.a:currentWord.">",l:path,'1','krl') == 0)
        call knop_extras#VerboseEcho("Found src file. The quickfix window will open. See :he quickfix-window",1)
        return 0
        "
      endif
    finally
      let &fileignorecase = l:saved_fileignorecase
      unlet l:saved_fileignorecase
    endtry
    "
    " third search global def(fct)?
    call knop_extras#VerboseEcho("Search global def(fct)? definitions in &path...")
    if (knop_extras#SearchPathForPatternNTimes('\c\v^\s*global\s+def(fct\s+\w+(\[[0-9,]*\])?)?\s+'.a:currentWord.">",knop_extras#PreparePath(&path,'*.[sS][rR][cC]').knop_extras#PreparePath(&path,'*.[sS][uU][bB]'),'1','krl') == 0)
      call knop_extras#VerboseEcho("Found global def(fct)? declaration. The quickfix window will open. See :he quickfix-window",1)
      return 0
      "
    endif
    "
    call knop_extras#VerboseEcho("Nothing found.",1)
    return -1
  endfunction " s:KrlSearchProc()

  function <SID>KrlGoDefinition() abort
    "
    let l:declPrefix = '\c\v^\s*((global\s+)?(const\s+)?(bool|int|real|char|frame|pos|axis|e6pos|e6axis|signal|channel)\s+[a-zA-Z0-9_,\[\] \t]*|(decl\s+)?(global\s+)?(struc|enum)\s+|decl\s+(global\s+)?(const\s+)?\w+\s+[a-zA-Z0-9_,\[\] \t]*)'
    "
    " suche das naechste wort
    if search('\w','cW',line("."))
      "
      let l:currentWord = krl_extras#CurrentWordIs()
      "
      if l:currentWord =~ '^sysvar.*'
        let l:currentWord = substitute(l:currentWord,'^sysvar','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a KSS VARIABLE"])
        return s:KrlSearchSysvar(l:declPrefix,l:currentWord)
        "
      elseif l:currentWord =~ '^var.*'
        let l:currentWord = substitute(l:currentWord,'^var','','')
        let l:currentWord = substitute(l:currentWord,'\(\w\+\)\$','\1\\$','g') " escape embeddend dollars in var name (e.g. TMP_$STOPM)
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a user defined VARIABLE"])
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
        let l:currentWord = substitute(l:currentWord,'\$','\\$','g') " escape dollars in proc/func name (e.g. $xx_IDENT())
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a ".l:type])
        return s:KrlSearchProc(l:currentWord)
        "
      elseif l:currentWord =~ '^inst.*'
        let l:currentWord = substitute(l:currentWord,'^inst','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a KRL KEYWORD. Maybe a Struc or Enum."])
        return s:KrlSearchVar(l:declPrefix,l:currentWord)
        "
      elseif l:currentWord =~ '^enumval.*'
        let l:currentWord = substitute(l:currentWord,'^enumval','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be an ENUM VALUE."],1)
        return s:KrlSearchEnumVal('\v\c^\s*(global\s+)?enum\s+\w+\s+[0-9a-zA-Z_, \t]*',substitute(l:currentWord,'^#','',''))
        "
      elseif l:currentWord =~ '^header.*'
        let l:currentWord = substitute(l:currentWord,'^header','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a HEADER. No search performed."],1)
      elseif l:currentWord =~ '^num.*'
        let l:currentWord = substitute(l:currentWord,'^num','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a NUMBER. No search performed."],1)
      elseif l:currentWord =~ '^bool.*'
        let l:currentWord = substitute(l:currentWord,'^bool','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a BOOLEAN VALUE. No search performed."],1)
      elseif l:currentWord =~ '^string.*'
        let l:currentWord = substitute(l:currentWord,'^string','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a STRING. No search performed."],1)
      elseif l:currentWord =~ '^comment.*'
        let l:currentWord = substitute(l:currentWord,'^comment','','')
        if krl#IsVkrc() 
          if (l:currentWord=~'\cup\d\+' || l:currentWord=~'\cspsmakro\d\+' || l:currentWord=~'\cfolge\d\+')
            call knop_extras#VerboseEcho([l:currentWord,"appear to be a VKRC CALL."])
            let l:currentWord = substitute(l:currentWord,'\c^spsmakro','makro','')
            return s:KrlSearchProc(l:currentWord)
          elseif l:currentWord =~ '\c\<m\d\+\>'
            call knop_extras#VerboseEcho([l:currentWord,"appear to be a VKRC MARKER."])
            return s:KrlSearchVkrcMarker(l:currentWord)
          elseif l:currentWord =~ '\c\<bin\(in\)\?\d\+\>'
            call knop_extras#VerboseEcho([l:currentWord,"appear to be a VKRC binary signal."])
            return s:KrlSearchVkrcBin(l:currentWord)
          endif
        endif
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a COMMENT. No search performed."],1)
      else
        let l:currentWord = substitute(l:currentWord,'^none','','')
        call knop_extras#VerboseEcho([l:currentWord,"Could not determine typ of current word. No search performed."],1)
      endif
      return -1
      "
    endif
    "
    call knop_extras#VerboseEcho("Unable to determine what to search for at current cursor position. No search performed.",1)
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
        call knop_extras#VerboseEcho("\nFile does already exists! Use\n :edit ".l:sFilename,1)
        return ''
        "
      elseif &mod && !&hid
        call knop_extras#VerboseEcho("\nWrite current buffer first!",1)
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
        call knop_extras#VerboseEcho("shift down because of &header")
        normal! j
      endwhile
      if line('.')==line('$')
            \&& getline('.')=~l:headerline
        normal! o
        call knop_extras#VerboseEcho("started after header")
        "
        let g:krlPositionSet = 1
        return
        "
      elseif getline('.')=~l:emptyline
        if getline(line('.')+1)!=l:emptyline
          normal! O
        endif
        call knop_extras#VerboseEcho("started after header")
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
      call knop_extras#VerboseEcho("started before def line")
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
      call knop_extras#VerboseEcho("started after enddef line")
      "
      let g:krlPositionSet = 1
      return
      "
    elseif l:startlinenum==1
      " start on line 1
      if search(l:defline,'cW')
        call knop_extras#VerboseEcho("found first def")
        call s:KrlPositionForEdit()
        return
      endif
      if l:startline!~l:emptyline
        normal! O
      endif
      if getline(line('.')+1)!~l:emptyline
        normal! O
      endif
      call knop_extras#VerboseEcho("started at line 1")
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
      call knop_extras#VerboseEcho("started at line $")
      "
      let g:krlPositionSet = 1
      return
      "
    else
      " start in between
      if search(l:defline,'bcW')
        call search(l:enddefline,'cW')
        call knop_extras#VerboseEcho("found enddef line between")
        call s:KrlPositionForEdit()
        return
      elseif search(l:enddefline,'cW')
        call knop_extras#VerboseEcho("found enddef line between")
        call s:KrlPositionForEdit()
        return
      else
        " failsafe append to file
        normal! G
        normal! o
        normal! o
        call knop_extras#VerboseEcho("failsafe append")
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
    call knop_extras#VerboseEcho("KrlPositionForEdit finished",1)
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
      call knop_extras#VerboseEcho([l:sBodyFile,": Body file not readable."])
      return
    endif
    " read body
    call s:KrlPositionForRead()
    execute "silent .-1read ".glob(l:sBodyFile)
    " set marks
    let l:start = line('.')
    let l:end = search('\v\c^\s*end(fct|dat)?>','cnW')
    " substitute marks in body
    call knop_extras#SubStartToEnd('<name>',a:sName,l:start,l:end)
    call knop_extras#SubStartToEnd('<type>',a:sType,l:start,l:end)
    call knop_extras#SubStartToEnd('<\%(global\|public\)>',a:sGlobal,l:start,l:end)
    " set another mark after the def(fct|dat)? line is present
    let l:defstart = search('\v\c^\s*(global\s+)?def(fct|dat)?>','cnW')
    call knop_extras#SubStartToEnd('<datatype>',a:sDataType,l:start,l:defstart)
    call knop_extras#SubStartToEnd('<returnvar>',a:sReturnVar,l:start,l:defstart)
    " correct array
    let l:sDataType = substitute(a:sDataType,'\[.*','','')
    let l:sReturnVar = a:sReturnVar . "<>" . a:sDataType
    let l:sReturnVar = substitute(l:sReturnVar,'<>\w\+\(\[.*\)\?','\1','')
    call knop_extras#SubStartToEnd('<datatype>',l:sDataType,l:defstart+1,l:end)
    call knop_extras#SubStartToEnd('<returnvar>',l:sReturnVar,l:defstart+1,l:end)
    call knop_extras#SubStartToEnd('\v(^\s*return\s+\w+\[)\d+(,)?\d*(,)?\d*(\])','\1\2\3\4',l:defstart+1,l:end)
    " upper case?
    if get(g:,'krlAutoFormUpperCase',0)
      call knop_extras#UpperCase(l:defstart,l:end)
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
      call knop_extras#UpperCase(line('.'),search('\v\c^\s*enddat>','cnW'))
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
      call knop_extras#UpperCase(line('.'),search('\v\c^\s*end>','cnW'))
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
      call knop_extras#UpperCase(line('.'),search('\v\c^\s*endfct>','cnW'))
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
        call knop_extras#VerboseEcho("\nBody file will be used")
        call knop_extras#VerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'defdat.dat',1)
        call s:KrlReadBody('defdat.dat',l:sType,l:sName,l:sGlobal,'','')
      else
        if exists("g:krlPathToBodyFiles")
          call knop_extras#VerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'defdat.dat')
          call knop_extras#VerboseEcho(" is not readable!")
        endif
        call knop_extras#VerboseEcho("\nDefault body will be used",1)
        call s:KrlDefaultDefdatBody(l:sName,l:sGlobal)
      endif
      "
    elseif l:sType =~ '^def\>'
      "
      let l:sName = s:KrlGetNameAndOpenFile('\c\v(src|sub)')
      if l:sName == '' | return | endif
      if exists("g:krlPathToBodyFiles") && filereadable(glob(fnameescape(g:krlPathToBodyFiles)).'def.src')
        call knop_extras#VerboseEcho("\nBody file will be used")
        call knop_extras#VerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'def.src',1)
        call s:KrlReadBody('def.src',l:sType,l:sName,l:sGlobal,'','')
      else
        if exists("g:krlPathToBodyFiles")
          call knop_extras#VerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'def.src')
          call knop_extras#VerboseEcho(" is not readable!")
        endif
        call knop_extras#VerboseEcho("\nDefault body will be used",1)
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
        call knop_extras#VerboseEcho("\nBody file will be used")
        call knop_extras#VerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'deffct.src',1)
        call s:KrlReadBody('deffct.src',l:sType,l:sName,l:sGlobal,l:sDataType,l:sReturnVar)
      else
        if exists("g:krlPathToBodyFiles")
          call knop_extras#VerboseEcho(glob(fnameescape(g:krlPathToBodyFiles)).'deffct.src')
          call knop_extras#VerboseEcho(" is not readable!")
        endif
        call knop_extras#VerboseEcho("\nDefault body will be used",1)
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
    if knop_extras#SearchPathForPatternNTimes('\v\c^\s*(global\s+)?def(fct)?>','%','','krl')==0
      call setqflist([], ' ', {'items' : getqflist(), 'quickfixtextfunc' : 'KnopEraseQFPaths', 'nr': "$"})
      call knop_extras#OpenQf('krl',"don't format'")
    else
      call knop_extras#VerboseEcho("Nothing found.",1)
    endif
  endfunction " <SID>KrlListDefinition()

  function <SID>KrlListUsage() abort
    "
    if search('\w','cW',line("."))
      let l:currentWord = krl_extras#CurrentWordIs()
      let l:type = ''
      "
      if l:currentWord =~ '^sysvar.*'
        let l:type = 'SYSVAR'
        let l:currentWord = substitute(l:currentWord,'^sysvar','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a KSS VARIABLE"])
        let l:currentWord = substitute(l:currentWord,'\$','\\$','g') " escape any dollars in var name
      elseif l:currentWord =~ '^header.*'
        let l:type = 'HEADER'
        let l:currentWord = substitute(l:currentWord,'^header','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a HEADER."])
        let l:currentWord = substitute(l:currentWord,'&','\\&','g') " escape any & in var name
      elseif l:currentWord =~ '^var.*'
        let l:type = 'USERVAR'
        let l:currentWord = substitute(l:currentWord,'^var','','')
        let l:currentWord = substitute(l:currentWord,'\$','\\$','g') " escape embeddend dollars in var name (e.g. TMP_$STOPM)
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a user defined VARIABLE"])
      elseif l:currentWord =~ '\v^%(sys)?%(proc|func)'
        let l:type = 'DEF'
        if l:currentWord =~ '^sys'
          let l:type = 'KSS ' . l:type
        endif
        if l:currentWord =~ '^\v%(sys)?func'
          let l:type = l:type . 'FCT'
        endif
        let l:currentWord = substitute(l:currentWord,'\v^%(sys)?%(proc|func)','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a ".l:type])
      elseif l:currentWord =~ '^enumval.*'
        let l:type = 'ENUMVALUE'
        let l:currentWord = substitute(l:currentWord,'^enumval','','')
        let l:currentWord = substitute(l:currentWord,'\v(#)(\w+)','(\1\2|(decl\\s+)?(global\\s+)?enum\\s+\\w+\\s+[0-9a-zA-Z_, \t]*\2)','') " search also without # to find the declaration
        call knop_extras#VerboseEcho([l:currentWord,"appear to be an ENUM VALUE."])
      elseif l:currentWord =~ '^num.*'
        let l:type = 'NUMERIC'
        let l:currentWord = substitute(l:currentWord,'^num','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a NUMBER."])
      elseif l:currentWord =~ '^string.*'
        let l:type = 'STRING'
        let l:currentWord = substitute(l:currentWord,'^string','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a STRING."])
      elseif l:currentWord =~ '^comment.*'
        let l:type = 'COMMENT'
        let l:currentWord = substitute(l:currentWord,'^comment','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a COMMENT."])
      elseif l:currentWord =~ '^inst.*'
        let l:type = 'INSTRUCTION'
        let l:currentWord = substitute(l:currentWord,'^inst','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a KRL KEYWORD."])
      elseif l:currentWord =~ '^bool.*'
        let l:type = 'BOOL'
        let l:currentWord = substitute(l:currentWord,'^bool','','')
        call knop_extras#VerboseEcho([l:currentWord,"appear to be a BOOL VALUE."])
      else
        let l:type = 'NONE'
        let l:currentWord = substitute(l:currentWord,'^none','','')
        call knop_extras#VerboseEcho([l:currentWord,"Unable to determine what to search for at current cursor position. No search performed!"],1)
        return
        "
      endif
      call krl_extras#AlterIsKeyWord(1)
      let l:nonecomment = ''
      if !krl#IsVkrc()
        let l:nonecomment = '^[^;]*'
      endif
      if knop_extras#SearchPathForPatternNTimes('\c\v'.l:nonecomment.'<'.l:currentWord.'>',
            \ knop_extras#PreparePath(&path,'*.[sS][rR][cC]').' '
            \.knop_extras#PreparePath(&path,'*.[sS][uU][bB]').' '
            \.knop_extras#PreparePath(&path,'*.[dD][aA][tT]').' '
            \.knop_extras#PreparePath(&path,'*.[kK][fF][dD]').' '
            \.knop_extras#PreparePath(&path,'*.[kK][xX][rR]').' '
            \.knop_extras#PreparePath(&path,'*.[cC][oO][nN][fF][iI][gG]').' '
            \,'','krl')==0
        call setqflist(knop_extras#UniqueListItems(getqflist()))
        " rule out ENUM declaration if not looking for ENUM values
        let l:qftmp1 = []
        if l:type != 'ENUMVALUE'
          for l:i in getqflist()
            if get(l:i,'text') !~ '\v\c^\s*(global\s+)?enum>'
                  \|| get(l:i,'text') =~ '\v\c^\s*(global\s+)?enum\s+'.l:currentWord
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
        call knop_extras#VerboseEcho("Opening quickfix with results.",1)
        call knop_extras#OpenQf('krl')
      else
        call knop_extras#VerboseEcho("Nothing found.",1)
      endif
      call krl_extras#ResetIsKeyWord()
    else
      call knop_extras#VerboseEcho("Unable to determine what to search for at current cursor position. No search performed.",1)
    endif
  endfunction " <SID>KrlListUsage()

  " }}} List Def/Usage

endif " !exists("*knop_extras#VerboseEcho()")

" Vim Settings {{{

" path for gf, :find etc
if get(g:,'krlPath',1)

  let s:pathcurrfile = knop_extras#Fnameescape4Path(substitute(expand("%:p:h"), '\\', '/', 'g'))
  if s:pathcurrfile =~ '\v\c\/krc%(\/[^/]+){,5}$'
    " KRC found. Use that one
    let s:krlpath=substitute(s:pathcurrfile, '\c\v(\/krc)\/%(%(<krc>)@!.)*$', '\1/**,' ,'g')
  elseif s:pathcurrfile =~ '\v\c\/r1%(\/[^/]+){,4}$'
        \&& (     knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Mada',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Program',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/System',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/TP',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Folgen',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/Makros',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/UPs',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v%(\/r1)\/%(%(<r1>)@!.)*$','/R1/VW_User',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,   '\c\v(\/MaDa)%(\/r1)\/%(%(<r1>)@!.)*$','\1',''))
        \     ||  knop_extras#DirExists(substitute(s:pathcurrfile,'\c\v(\/PowerOn)%(\/r1)\/%(%(<r1>)@!.)*$','\1',''))
        \    )
    if s:pathcurrfile =~ '\c\v\/MaDa\/R1$'
      " krc1 MaDa/R1/ found, search for PowerOn as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/MaDa)\/R1$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cMaDa$', 'PowerOn' ,'')
      if knop_extras#DirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    elseif s:pathcurrfile =~ '\c\v\/PowerOn\/R1$'
      " krc1 PowerOn/R1/ found, search for MaDa as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/PowerOn)\/R1$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cPowerOn$', 'MaDa' ,'')
      if knop_extras#DirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    else
      " > krc1 R1 found, search for STEU as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/R1)\/%(%(<R1>)@!.)*$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cR1$', 'STEU' ,'')
      if knop_extras#DirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    endif
  elseif s:pathcurrfile =~ '\v\c\/Steu%(\/[^/]+){,1}$'
    if s:pathcurrfile =~ '\c\v\/MaDa\/Steu$'
      " krc1 MaDa/Steu/ found, search for PowerOn as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/MaDa)\/Steu$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cMaDa$', 'PowerOn' ,'')
      if knop_extras#DirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    elseif s:pathcurrfile =~ '\c\v\/PowerOn\/Steu$'
      " krc1 PowerOn/Steu/ found, search for MaDa as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/PowerOn)\/Steu$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cPowerOn$', 'MaDa' ,'')
      if knop_extras#DirExists(s:pathcurrfile)
        let s:krlpath=s:krlpath. s:pathcurrfile. '/**,'
      endif
    else
      " > krc1 STEU found, search for R1 as well
      let s:pathcurrfile = substitute(s:pathcurrfile, '\c\v(\/Steu)\/%(%(<Steu>)@!.)*$', '\1' ,'g')
      let s:krlpath=s:pathcurrfile. '/**,'
      let s:pathcurrfile = substitute(s:pathcurrfile, '\cSteu$', 'R1' ,'')
      if knop_extras#DirExists(s:pathcurrfile)
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

  call knop_extras#VerboseEcho("'path' set to: " . s:krlpath)
  execute "setlocal path=".s:krlpath
  let b:undo_ftplugin = b:undo_ftplugin." pa<"

endif " get(g:,'krlPath',1)

" complete
let s:pathList = knop_extras#SplitAndUnescapeCommaSeparatedPathStr(&path)
let s:pathToCurrentFile = substitute(expand("%:p:h"),'\\','/','g')
"
" complete custom files
if exists('g:krlCompleteCustom')
  for s:customCompleteAdditions in g:krlCompleteCustom
    let s:file = substitute(s:customCompleteAdditions,'^.*[\\/]\(\$?\w\+\.\)\(\w\+\)$','\1\2','')
    call knop_extras#AddFileToCompleteOption(s:customCompleteAdditions,s:pathList,s:pathToCurrentFile.'/'.s:file,)
  endfor
endif
"
" complete standard files
if get(g:,'krlCompleteStd',1)
  "
  " <filename>.dat
  if expand("%:p:t") !~ '\c\.dat$'
    call knop_extras#AddFileToCompleteOption(substitute(expand("%:p:t"),'\c\.s\%(rc\|ub\)$','.dat',''),[s:pathToCurrentFile])
  endif
  call knop_extras#AddFileToCompleteOption('R1/System/MsgLib.src'        , s:pathList  , s:pathToCurrentFile.'/'.'MsgLib.src')
  call knop_extras#AddFileToCompleteOption('R1/System/bas.src'           , s:pathList  , s:pathToCurrentFile.'/'.'bas.src')
  call knop_extras#AddFileToCompleteOption('R1/System/$config.dat'       , s:pathList  , s:pathToCurrentFile.'/'.'$config.dat')
  call knop_extras#AddFileToCompleteOption('R1/System/Global_Points.dat' , s:pathList  , s:pathToCurrentFile.'/'.'Global_Points.dat')
  call knop_extras#AddFileToCompleteOption('R1/System/MsgLib.src'        , s:pathList  , s:pathToCurrentFile.'/'.'MsgLib.src')
  call knop_extras#AddFileToCompleteOption('R1/Mada/$machine.dat'        , s:pathList  , s:pathToCurrentFile.'/'.'$machine.dat')
  call knop_extras#AddFileToCompleteOption('R1/Mada/$robcor.dat'         , s:pathList  , s:pathToCurrentFile.'/'.'$robcor.dat')
  call knop_extras#AddFileToCompleteOption('Steu/Mada/$custom.dat'       , s:pathList  , s:pathToCurrentFile.'/'.'$custom.dat')
  call knop_extras#AddFileToCompleteOption('Steu/Mada/$machine.dat'      , s:pathList) " fallback auf aktuelles verzeichnis s.o. R1/Mada/
  call knop_extras#AddFileToCompleteOption('Steu/Mada/$option.dat'       , s:pathList  , s:pathToCurrentFile.'/'.'$option.dat')
  call knop_extras#AddFileToCompleteOption('R1/TP/Signals.dat'           , s:pathList  , s:pathToCurrentFile.'/'.'Signals.dat')
  "
  " syntax file
  let s:pathList=[]
  for s:i in split(&rtp,'\\\@1<!,')
    call add(s:pathList,substitute(s:i,'\\','/','g')) 
  endfor
  call knop_extras#AddFileToCompleteOption('syntax/krl.vim',s:pathList)
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
