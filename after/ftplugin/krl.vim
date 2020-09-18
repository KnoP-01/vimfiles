nnoremap <F1> :if expand('%')=~'\.dat$' 
			\<bar> e %:s?\.dat$?.src? 
			\<bar> else 
			\<bar> e %:s?\.src$?.dat? 
			\<bar> endif<CR>

" global substitute
nmap <leader>gs :set hidden<cr>*N<leader>u:cdo s///g<left><left>

" indention settings
" setlocal softtabstop=4
" setlocal shiftwidth=4
" setlocal expandtab
" setlocal shiftround
