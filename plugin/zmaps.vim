" zmaps.vim: Helpful z maps
" Author:    Charles E. Campbell
" Date:      Nov 27, 2015
" Version:	 1e	ASTRO-ONLY
"
" Usage: {{{1
"  z<  shift text left
"  z>  shift text right
"  z,  move cursor to middle             of screen
"  z;  shift text under cursor to middle of screen
"  z0  move cursor to left-hand-side     of screen
"  z$  move cursor to right-hand-side    of screen
"  zp  put text (like "p") but keep cursor in same column
"  zP  Put text (like "P") but keep cursor in same column
"
" Don't forget vim's
"  zs  scroll text so cursor cursor at left-hand  side (start) of screen
"  ze  scroll text so cursor cursor at right-hand side (end)   of screen
"
" Internal Functions: {{{1
"  s:ZComma()  s:Zput()  ZPut()
"  These functions set lz and unset lz, but use no registers or marks

" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_zmaps")
 finish
endif
let g:loaded_zmaps = "v1e"
let s:keepcpo      = &cpo
set cpo&vim

" ---------------------------------------------------------------------
" New Z Maps: {{{1
nno <silent> z<	:<c-u>exe "norm! ".(((v:count <= 0)? 1 : v:count)*shiftwidth())."zl"<cr>
nno <silent> z>	:<c-u>exe "norm! ".(((v:count <= 0)? 1 : v:count)*shiftwidth())."zh"<cr>
nno <silent> z; :<c-u>call <SID>ZSemicolon()<cr>
nno <silent> z,	:<c-u>call <SID>ZComma()<CR>
nno <silent> z0	g0
nno <silent> z$	g$
nno <silent> zp	:<c-u>call <SID>Zput("p")<CR>
nno <silent> zP	:<c-u>call <SID>Zput("P")<CR>

nno <silent> p	:<c-u>call <SID>Zput("p")<CR>
nno <silent> P	:<c-u>call <SID>Zput("P")<CR>

" ---------------------------------------------------------------------
" Z Map Support Functions: {{{1

" ---------------------------------------------------------------------
" s:ZComma: puts cursor into middle of screen {{{2
fun! s:ZComma()
  let save_lz=&lz
  set lz
  norm z$
  let z1=virtcol(".")
  norm z0
  let z0     = virtcol(".")
  let zcomma = (z1-z0)/2
  exe "norm "zcomma."l"
  let &lz= save_lz
endfun

" ---------------------------------------------------------------------
" s:ZSemicolon: horizontally shifts text so that the text under the {{{2
"               the cursor is centered
fun! s:ZSemicolon()
"  call Dfunc("s:ZSemicolon()")
  let save_lz=&lz
  set lz
  let wc = wincol()
  let ww = winwidth(0)/2
  if ww != wc
	if wc < ww
	 " need to shift text to the right
	 exe "norm! ".(ww - wc)."zh"
	elseif wc > ww/2
	 " need to shift text to the left
	 exe "norm! ".(wc - ww)."zl"
	endif
   endif
  let &lz= save_lz
"  call Dret("s:ZSemicolon")
endfun

" ---------------------------------------------------------------------
" s:Zput: does a put/Put but retains cursor position {{{2
fun! s:Zput(put)
  let save_lz=&lz
  set lz
  let zp=virtcol(".")-1
  if zp > 0
   if v:register != ""
	exe 'norm! '.v:count1.'"'.v:register.a:put
	exe 'norm! 0'.zp."l"
   else
	exe "norm! ".v:count1.a:put
	exe 'norm! 0'.zp."l"
   endif
  else
    if v:register != ""
	 exe 'norm! '.v:count1.'"'.v:register.a:put
	else
	 exe "norm! ".v:count1.a:put
	endif
  endif
  let &lz= save_lz
endfun

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
"  vim: ts=4 fdm=marker
