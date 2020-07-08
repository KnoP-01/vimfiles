
" global substitute
nmap <leader>gs :set hidden<cr>*N u:cdo s///g<left><left>

" keyword lookup with K
if has("win32")
  let g:rapidPathToSumatraPDF='c:\apps\SumatraPDF\SumatraPDF.exe'
  let g:rapidPathToRefGuide='d:\daten\doku\abb\RefGuide_RW6.10\abb_reference_inst_func_dat.pdf'
  nnoremap <buffer> <silent> K :let rapidCmd=
        \"! start '" . 
        \g:rapidPathToSumatraPDF . 
        \"' -named-dest \\\"" . 
        \expand("<cword>") . 
        \" -\\\" '" . 
        \g:rapidPathToRefGuide . 
        \"'"<bar>
        \silent execute rapidCmd<cr>
endif

" indention settings
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal shiftround

" align robtarget values for readability
nnoremap <leader>abb  :Align! p0P0llrlrlrlrlrlrlrllllrlrlrlrlrlrl \. , \[ \]<cr>
xnoremap <leader>abb  :Align! p0P0llrlrlrlrlrlrlrllllrlrlrlrlrlrl \. , \[ \]<cr>

" align EIO.cfg for readability
function AlignEio()
  %s/\\\s*\n\s\+/\\ /
  g/^\s*$/d
  normal gg
  call search('\<EIO_SIGNAL\>')
  normal j0
  Align -SignalType -SignalLabel -UnitMap -Category -Unit
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
