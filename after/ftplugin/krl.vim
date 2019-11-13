nnoremap <F1> :if expand('%')=~'\.dat$' 
			\<bar> e %:s?\.dat$?.src? 
			\<bar> else 
			\<bar> e %:s?\.src$?.dat? 
			\<bar> endif<CR>

" setlocal softtabstop=4
" setlocal shiftwidth=4
" setlocal expandtab
" setlocal shiftround
