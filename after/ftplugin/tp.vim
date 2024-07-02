" augroup auTpOnBufWritePre
"   au! BufWritePre \c*.ls,\c*.pe call FixTpLineNum()
" augroup END
function! FixTpLineNum() abort
  let l:winview = winsaveview()
  let l:i = 1
  silent! %s/^\s*\d\+:/\=printf('%4d:', l:i.execute('let l:i+=1'))/g
  call winrestview(l:winview)  
endfunction
