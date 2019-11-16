set autoindent
call matchadd('colorcolumn','\%81v')

if (get(g:,'colors_name'," ")=="tortus" || get(g:,'colors_name'," ")=="tortusless") 
	hi link helpExample    Operator
	hi link helpCommand    Operator
elseif get(g:,'colors_name'," ")=="gruvbox"
	hi link helpExample    String
	hi link helpCommand    String
else
	hi link helpExample    Statement
	hi link helpCommand    Statement
endif

