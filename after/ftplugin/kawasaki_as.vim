" Vim filetype plugin
" Language: Kawasaki AS-language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 15. Aug 2023
"

nnoremap <leader>f :vimgrep /^.program /j %<CR>
nnoremap gd /\c^\(.program \<bar>\$\<bar>#\)\?\>/<CR>

" vim:sw=2 sts=2 et fdm=marker

