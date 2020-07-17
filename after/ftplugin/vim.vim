" delete comment leader (") if J(oin) is used
setlocal fo+=j
" dont insert comment leader on i_<CR> or o or O
" setlocal fo-=ro

" the following is done by a modeline
" set softtabstop=2
" set shiftwidth=2
" set expandtab

vnoremap <silent>af :<C-U>silent normal [[V][<CR>
vnoremap <silent>if :<C-U>silent normal [[jV][k<CR>
omap <silent>af :normal Vaf<CR>
omap <silent>if :normal Vif<CR>


" highlight ! as operator
syntax match vimOper /!/
" highlight default link vimOper Operator

