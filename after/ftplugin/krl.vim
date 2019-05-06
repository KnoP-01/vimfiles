nnoremap <F1> :if expand('%')=~'\.dat' 
			\<bar> e %:s?\.dat$?.src? 
			\<bar> else 
			\<bar> e %:s?\.src$?.dat? 
			\<bar> endif<CR>
