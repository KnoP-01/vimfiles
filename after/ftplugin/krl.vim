nnoremap <F1> :if expand('%:t')=~'dat' 
			\<bar> e %:r.src 
			\<bar> else 
			\<bar> e %:r.dat 
			\<bar> endif<CR>

" global substitute
nmap <leader>gs :set hidden<cr>*N<leader>u:cdo s///g<left><left>

" indention settings
" setlocal softtabstop=4
" setlocal shiftwidth=4
" setlocal expandtab
" setlocal shiftround
