" my perl modifications

" compile perl script for syntax check
nnoremap <buffer> <F4> :!perl -wc %<CR>

" setlocal shell=cmd.exe
" setlocal shellcmdflag=-c
" setlocal noshellslash
" setlocal guioptions-=!     " don't open cmd.exe-window on windows in case of :!

setlocal makeprg=c:/apps/bin/vim_tools/efm_perl.pl\ -c\ %\ $*
setlocal errorformat=%f:%l:%m

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
