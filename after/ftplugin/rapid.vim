nmap <silent><buffer> <leader>f <Plug>RapidListDef
nmap <silent><buffer> <leader>u <Plug>RapidListUse
nmap <silent><buffer> gd <Plug>RapidGoDef

" conceal
" alternative for g:rapidConcealStructsKeyMap
nmap <silent><buffer> <F2> <Plug>RapidConcealStructs
nmap <silent><buffer> <F4> <Plug>RapidShowStructs
" alternative for g:rapidConcealStructs
if getbufvar('%', "&buftype")!="quickfix" 
  " setlocal conceallevel=2 concealcursor=nc
  setlocal conceallevel=0 concealcursor=nc
endif
" additional
nnoremap <silent><buffer> <F3> :if &concealcursor=='' <bar> set concealcursor=nc <bar> else <bar> set concealcursor= <bar> endif<cr>

" vim:sw=2 sts=2 et fdm=marker
