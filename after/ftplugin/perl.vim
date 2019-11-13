" my perl modifications

" compile perl script for syntax check
nnoremap <buffer> <F4> :!perl -c %<CR>

" tabs
setlocal softtabstop=4
setlocal expandtab
setlocal shiftwidth=4


" delete comment leader (") if J(oin) is used
setlocal fo+=j fo-=r fo-=o

setlocal iskeyword-=:
setlocal iskeyword+=$
setlocal iskeyword+=@-@
setlocal iskeyword+=%
setlocal iskeyword+=&
