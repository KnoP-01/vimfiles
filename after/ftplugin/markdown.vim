set textwidth=78
call matchadd('colorcolumn','\%81v')

if (get(g:,'colors_name'," ")=="tortus" || get(g:,'colors_name'," ")=="tortusless") 
	" hi link helpExample    Operator
	" hi link helpCommand    Operator
elseif get(g:,'colors_name'," ")=="gruvbox"
	hi link markdownCodeBlock    String
	hi link markdownCode         String
else
  hi link markdownCodeBlock     Statement
  hi link markdownCode          Statement
endif

setlocal softtabstop=4
setlocal expandtab
setlocal shiftwidth=4

setlocal conceallevel=2
