nnoremap <F1> :if expand('%')=~'\.dat$' 
			\<bar> e %:s?\.dat$?.src? 
			\<bar> else 
			\<bar> e %:s?\.src$?.dat? 
			\<bar> endif<CR>

" center when moving to previews/next func
nmap <buffer> g[[ [[zt
nmap <buffer> g]] ]]zt
nmap <buffer> g[] []zb
nmap <buffer> g][ ][zb

" setlocal softtabstop=4
" setlocal shiftwidth=4
" setlocal expandtab
" setlocal shiftround
