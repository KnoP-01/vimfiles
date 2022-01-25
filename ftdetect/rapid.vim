" ABB Rapid Command file type detection for Vim
" Language: ABB Rapid Command
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 2.0.5
" Last Change: 26. Dec 2021
" Credits:
"
" Suggestions of improvement are very welcome. Please email me!
"

let s:keepcpo= &cpo
set cpo&vim

" change default autocmd
augroup filetypedetect
  au! BufNewFile *.prg,*.Prg,*.PRG
        \  if exists("g:filetype_prg")
        \|   exe "setf " . g:filetype_prg
        \| else
        \|   setf rapid
        \| endif
  au! BufRead *.prg,*.Prg,*.PRG
        \  if s:ftIsRapid()
        \|   setf rapid
        \| elseif exists("g:filetype_prg")
        \|   exe "setf " . g:filetype_prg
        \| else
        \|   setf clipper
        \| endif
  au! BufNewFile *.mod,*.Mod,*.MOD
        \  if exists("g:filetype_mod")
	\|   exe "setf " . g:filetype_mod
	\| elseif exists("*dist#ft#FTmod()")
        \|   call dist#ft#FTmod()
        \| else
        \|   setf rapid
        \| endif
  au! BufRead *.mod,*.Mod,*.MOD
        \  if exists("*dist#ft#FTmod()")
        \|   call dist#ft#FTmod()
        \| elseif s:ftIsRapid()
        \|   setf rapid
        \| elseif getline(nextnonblank(1)) =~# '\<MODULE\s\+\w\+;'
        \|   setf modsim3
        \| elseif getline(s:nextLPrologCodeLine(1)) =~# '<module\s\+\w\+\.'
        \|   setf lprolog
        \| elseif expand("<afile>") =~ '\<go.mod$'
        \|   setf gomod
        \| endif
  au! BufNewFile *.sys,*.Sys,*.SYS
        \  setf rapid 
  au! BufRead *.sys,*.Sys,*.SYS
        \  if s:ftIsRapid()
        \|   setf rapid 
        \| else 
        \|   setf dosbatch 
        \| endif
  au! BufNewFile *.cfg,*.Cfg,*.CFG
        \  setf rapid
  au! BufRead *.cfg,*.Cfg,*.CFG
        \  if getline(1) =~? '\c\v^' . expand('<afile>:t:r') . ':CFG'
        \|   call <SID>RapidDetectFTandCorrEOL() 
        \| else 
        \|   setf cfg 
        \| endif
augroup END

if !exists("*<SID>RapidDetectFTandCorrEOL()")

  function <SID>RapidDetectFTandCorrEOL() abort
    setf rapid
    if get(g:,'rapidAutoCorrCfgLineEnd',1)
      silent! %s/\r//
      normal ``
    endif
  endfunction

  function s:ftIsRapid() abort
    return getline(nextnonblank(1)) =~? '%%%\|^\s*module\s\+\w\+\s*\%((\|$\)'
  endfunction

  function s:nextLPrologCodeLine(n) abort
    let s:n = nextnonblank(a:n)
    " skip lines that look like lprolog comments
    while s:n =~ '^\s*%'
      let s:n = nextnonblank(s:n+1)
    endwhile
    return s:n
  endfunction

endif

let &cpo = s:keepcpo
unlet s:keepcpo

" vim:sw=2 sts=2 et
