
" setlocal softtabstop=4
" setlocal shiftwidth=4
" setlocal expandtab
" setlocal shiftround

" align robtarget values for readability
nnoremap <leader>abb  :Align! p0P0rl \. , \[ \]<cr>
xnoremap <leader>abb  :Align! p0P0rl \. , \[ \]<cr>

" align EIO.cfg for readability
function AlignEio()
  %s/\\\s*\n\s\+/\\ /
  g/^\s*$/d
  normal gg
  call search('\<EIO_SIGNAL\>')
  normal j0
  Align -SignalType -SignalLabel -UnitMap -Category
  normal zt
endfunction
command! EioAlign call AlignEio()

" undo align EIO.cfg for readability
function UnAlignEio()
  g/\n[^#]/s/\([^#]\)$/\1\r/
  g/\\\s*\S/s/\\/\\\r/g
  %s/\s\s\+-/ -/g
  %s/^\s\+-/      -/
endfunction
command! EioUnAlign call UnAlignEio()

" vim:sw=2 sts=2 et fdm=marker fmr={{{,}}}
