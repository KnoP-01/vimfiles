" my perl modifications

let g:perl_compiler_force_warnings = 1
compiler perl

" fix gd (why is this not working by default?)
" nnoremap gd :keepjumps normal *<cr>:keepjumps normal gg<cr>:keepjumps normal n<cr>

" create <leader>f like in rapid/krl
nnoremap <leader>f :vimgrep /^\s*sub\s\+\w\+/ %<cr>

" compile perl script for syntax check
nnoremap <buffer> <F4> :make<CR>
nnoremap <buffer> <S-F4> :!perl -wc %<CR>

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

" Move around subroutines
nnoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^sub>', 'bs')         <Bar>unlet b:knopCount<CR>:normal! zt<CR>
onoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^sub>.*\n\zs', 'bsW') <Bar>unlet b:knopCount<CR>
xnoremap <silent><buffer> [[ :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^sub>', 'bsW')        <Bar>unlet b:knopCount<CR>
nnoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^sub>', 's')          <Bar>unlet b:knopCount<CR>:normal! zt<CR>
onoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^sub>', 'sW')         <Bar>unlet b:knopCount<CR>
xnoremap <silent><buffer> ]] :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^sub>.*\n', 'seWz')   <Bar>unlet b:knopCount<CR>
nnoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^}', 'bs')            <Bar>unlet b:knopCount<CR>:normal! zb<CR>
onoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^}\n^(.\|\n)', 'bseW')<Bar>unlet b:knopCount<CR>
xnoremap <silent><buffer> [] :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^}', 'bsW')           <Bar>unlet b:knopCount<CR>
nnoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^}', 's')             <Bar>unlet b:knopCount<CR>:normal! zb<CR>
onoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1                     <Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v\ze^}>', 'sW')        <Bar>unlet b:knopCount<CR>
xnoremap <silent><buffer> ][ :<C-U>let b:knopCount=v:count1<Bar>exe "normal! gv"<Bar>call <SID>KnopNTimesSearch(b:knopCount, '\c\v^}(\n)?', 'seWz')     <Bar>unlet b:knopCount<CR>

" text object subroutine
" TODO

" setlocal shell=cmd.exe
" setlocal shellcmdflag=-c
" setlocal noshellslash
" setlocal guioptions-=!     " don't open cmd.exe-window on windows in case of :!

setlocal makeprg=c:/apps/bin/vim_tools/efm_perl.pl\ -c\ %\ $*
setlocal errorformat=%f:%l:%m

" tabs
setlocal softtabstop=4
setlocal expandtab
setlocal shiftwidth=4


" delete comment leader (") if J(oin) is used
setlocal fo+=j fo-=r fo-=o

setlocal iskeyword-=:
" setlocal iskeyword+=$
" setlocal iskeyword+=@-@
" setlocal iskeyword+=%
" setlocal iskeyword+=&

" vim:sw=2 sts=2 et fdm=marker
