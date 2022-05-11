nnoremap <F1> :if expand('%:t:e')=~?'dat' 
			\<bar> e %:r.src 
			\<bar> else 
			\<bar> e %:r.dat 
			\<bar> endif<CR>

" global substitute
nmap <leader>gs :set hidden<cr>*N<leader>u:cdo s///g<left><left>

if exists('g:loaded_switch')

  let b:switch_custom_definitions =
        \ [
        \   {
        \     '\C\<TRUE\>'  : 'FALSE',
        \     '\C\<FALSE\>' : 'TRUE',
        \   },
        \   {
        \     '\C\<True\>'  : 'False',
        \     '\C\<False\>' : 'True',
        \   },
        \   {
        \     '\c\<true\>'  : 'false',
        \     '\c\<false\>' : 'true',
        \   },
        \   {
        \     '\C\<AND\>' : 'OR',
        \     '\C\<OR\>'  : 'EXOR',
        \     '\C\<EXOR\>' : 'AND',
        \   },
        \   {
        \     '\C\<And\>' : 'Or',
        \     '\C\<Or\>'  : 'ExOr',
        \     '\C\<ExOr\>' : 'And',
        \   },
        \   {
        \     '\c\<and\>'  : 'or',
        \     '\c\<or\>'   : 'exor',
        \     '\c\<exor\>' : 'and',
        \   },
        \   {
        \     '\c(\(not\)\@!'       : '(not ',
        \     '\c(not '             : '(',
        \     '\c\(not\)\@3<! (\@=' : ' not ',
        \     '\c not (\@='         : ' ',
        \   },
        \   {
        \     '=='  : '>=',
        \     '>=' : '<=',
        \     '<=' : '<>',
        \     '<>' : '==',
        \   },
        \   {
        \     '\C\v<B_AND>'   : 'B_OR',
        \     '\C\v<B_OR>'    : 'B_EXOR',
        \     '\C\v<B_EXOR>'  : 'B_AND',
        \   },
        \   {
        \     '\c\v<b_and>'   : 'b_or',
        \     '\c\v<b_or>'    : 'b_exor',
        \     '\c\v<b_exor>'  : 'b_and',
        \   }
        \ ]
endif
" indention settings
" setlocal softtabstop=4
" setlocal shiftwidth=4
" setlocal expandtab
" setlocal shiftround
