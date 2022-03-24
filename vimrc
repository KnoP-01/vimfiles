" .vimrc (C) Patrick Meiser-Knosowski aka KnoP

" don't copy this if you don't know what you are doing
" and think about the poor pandas if you do!

" {{{ init
" vim rather than vi
set nocompatible

" Language English
set langmenu=none
" if !has("win32") " del c:\Program Files (x86)\Vim\vim81\lang\de\
  language en_US
" endif

" set leader before any plugin, so <leader>-mappings get the right leader 
let mapleader       = " "
let maplocalleader  = " "
" }}}

" Optional Packs:
" packadd ... {{{
" packadd! matchit " use matchup instead of matchit see https://github.com/andymass/vim-matchup
packadd! editexisting " find existing session if .swp-file exists
packadd! shellmenu
packadd! cfilter
" }}}
" Plugins:
call plug#begin('~/.vim/plugged') " {{{

  " Make sure you use single quotes
  " examples see :he plug-example

  Plug 'vim/killersheep'

  " context
  Plug 'wellle/context.vim'
  let g:context_enabled = 0
  let g:context_filetype_blacklist = []
  nnoremap <leader>cc :ContextPeek<cr>
  nnoremap <leader>ce :ContextEnable<cr>
  nnoremap <leader>cd :ContextDisable<cr>

  " vim script test framework
  Plug 'junegunn/vader.vim'

  Plug 'KnoP-01/tortus'
  Plug 'KnoP-01/vimbuddy'
  " Plug 'KnoP-01/vim-tp', { 'branch': 'dev' }
  Plug 'KnoP-01/vim-karel'
  Plug 'KnoP-01/DrChipsCecutil'
  Plug 'KnoP-01/DrChipsAlign'
  let g:loaded_AlignMapsPlugin=1  " AlignMaps.vim; get rid of maps from AlignMapsPlugin
  Plug 'KnoP-01/DrChipsVis'

  " Align alternative
  Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces=1 " add 1 space befor and after

  " motoman plugin"
  " Plug 'matthijsk/motoman-inform-vim-syntax'
  Plug 'KnoP-01/motoman-inform-vim-syntax'

  " full screen mode for windows
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-shell'
  let g:shell_mappings_enabled          = 0
  let g:shell_fullscreen_always_on_top  = 0
  let g:shell_fullscreen_message        = 0

  " erweiterung fuer netrw
  Plug 'tpope/vim-vinegar'
  nmap - <C-W>v<Plug>VinegarUp
  " ein- und auskommentieren
  Plug 'tpope/vim-commentary'
  " auto-endif et al
  Plug 'tpope/vim-endwise'
  " repeat
  Plug 'tpope/vim-repeat'

  " erweiterung fuer quickfix und loclist
  Plug 'romainl/vim-qf'
  let g:qf_window_bottom         = 0
  let g:qf_loclist_window_bottom = 0
  let g:qf_mapping_ack_style     = 1

  " fun
  Plug 'uguu-org/vim-matrix-screensaver'
  " Plug 'KnoP-01/vim-matrix-screensaver'

  " fenster anordnen
  Plug 'andymass/vim-tradewinds'
  let g:tradewinds_no_maps = 1 " see <plug>(tradewinds-...
  " ersatz fuer matchit
  Plug 'andymass/vim-matchup'
  let g:matchup_matchparen_enabled          = 0         " dislable on startup
  let g:matchup_matchparen_status_offscreen = 0         " don't show off screen matches
  let g:matchup_mouse_enabled               = 0         " don't map any mouse actions
  " let g:matchup_matchparen_deferred             = 1     " delay until display matching paren
  " let g:matchup_matchparen_deferred_show_delay  = 800   " delay until display matching paren
  let g:matchup_matchparen_offscreen        = {'method':'popup'}

  " focus
  Plug 'blueyed/vim-diminactive/'
  " let g:diminactive_use_colorcolumn = 0 " see also ColorColumn
  " let g:diminactive_use_syntax = 1

  " Plug 'vim-scripts/RelOps'
  " let g:relops_check_for_nu = 1
  " let g:relops_mappings = ['gc']
  " Plug 'vim-scripts/increment.vim--Avadhanula'
  Plug 'mMontu/increment.vim--Avadhanula'

  " compare character wise with vimdiff
  Plug 'rickhowe/diffchar.vim'
  Plug 'rickhowe/spotdiff.vim'
  " avoid collision with krl- and rapid-<leader>u
  nmap <silent> <Leader>U <Plug>(VDiffupdate)

  " markdown
  Plug 'godlygeek/tabular'
  let g:vim_markdown_folding_disabled = 1
  Plug 'plasticboy/vim-markdown'
  " let g:instant_markdown_browser = "firefox --new-window"
  " let g:instant_markdown_python = 1
  " let g:instant_markdown_logfile = '.\instant_markdown.log'
  " Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

  " 
  Plug 'itchyny/landscape.vim'

  " switch between true/false...
  Plug 'AndrewRadev/switch.vim'
  " let g:switch_mapping = 'gs' " this one is default
  " let g:switch_mapping = '' " disabled b/c <plug> see below
  let g:switch_reverse_mapping = 'ga'
  " nnoremap <silent> <plug>SwitchFwd :Switch<cr>
  " nnoremap <silent> <plug>SwitchBwd :SwitchReverse<cr>
  " nmap gs <plug>SwitchFwd
  " nmap ga <plug>SwitchBwd

  " a monochrome colorscheme
  Plug 'jaredgorski/fogbell.vim'

call plug#end()
" PlugUpdate
command! MyPlugUpdate   :set statusline=%F%m%r%h%w shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugUpdate
" PlugInstall
command! MyPlugInstall  :set statusline=%F%m%r%h%w shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugInstall
" PlugClean
command! MyPlugClean    :set statusline=%F%m%r%h%w shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugClean
" don't forget PlugClean
" }}}
" Syntax And Filetype: " {{{
syntax off                          " undo what plug#end() did to syntax
filetype plugin indent off          " undo what plug#end() did to filetype
if &t_Co > 2 || has("gui_running")  " Switch syntax highlighting on, when the terminal has colors
  syntax on
endif
filetype plugin indent on           " filetype on after syntax on for krl-for-vim }}}

" Auto Commands:
augroup vimrcEx " {{{
  au!

  " relativenumber and cursorline only in current window
  autocmd BufEnter,WinEnter *                           setlocal    cursorline
  autocmd BufLeave,WinLeave *                           setlocal  nocursorline
  " autocmd BufEnter,WinEnter * if &filetype !=# 'help' | setlocal    relativenumber | endif
  " autocmd BufLeave,WinLeave * if &filetype !=# 'help' | setlocal  norelativenumber | endif

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " turbo risk pascal files
  autocmd BufNewFile,BufRead *.trp set syntax=TR_Pascal

  " Continue editing where left unless the position is invalid
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif

augroup END
" }}}

" Options:
" Other Options: {{{

" read UTF-8 files correctly
set fileencodings=ucs-bom,utf-8,latin1

" truecolor in terminals which support it. May not work in all cases!
if has('termguicolors') && $COLORTERM ==# 'truecolor' || has("win32")
  set termguicolors
endif

" 'wildmenu'
set wildchar=<Tab> wildcharm=<C-Z> wildmenu wildmode=full

" set listchars=tab:»·,trail:·,eol:$
set listchars=nbsp:~,tab:>-,trail:*,eol:$

set backspace=indent,eol,start    " allow backspacing over everything in insert mode

" better diff
set diffopt=filler,icase,iwhite   " settings for diff mode: keep window lines synchronised, ignore case, ignore different amount of white spaces
set diffopt+=internal,algorithm:patience
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis

set backup            " write a backup.file~
" set directory-=.      " redirect .swp files to C:\Users\<user>\AppData\Local\Temp

if has("win32")
  set shell=c:/apps/gitforwin/bin/bash.exe " use git for windows bash
  set shellcmdflag=-c
  set shellredir=>%s\ 2>&1
  set shellslash
  " ausprobieren
  " set shelltemp
  " set noshelltemp
  let &shellxescape = ''
  let &shellxquote = '"'
  set guioptions+=!     " don't open cmd.exe-window on windows in case of :!
endif

set guioptions+=a         " put visually selected text into * register (gui only)
set clipboard=autoselect  " same for terminals

set guioptions-=r     " no right scroll bar
set guioptions-=L     " no left scroll bar in case of vertical split
" set guioptions+=l     " left scroll bar. Siehe <S-F11> unten
" set guioptions+=R     " right scroll bar in case of vertical split. Siehe <S-F11> unten

set guioptions-=m    " kein Menu per default. Siehe <S-F11> unten
set guioptions-=T    " keine Toolbar per default. Siehe <S-F11> unten
set guioptions+=k    " keep window size when adding/removing menu/scrollbar

set nrformats-=octal  " don't use octal in case of leading 0

set scrolloff=2       " scroll offset at top or bottom
set sidescrolloff=8   " scroll offset at left or right

set history=50        " keep 50 lines of command line history

set laststatus=2      " always show status line

set incsearch         " do incremental searching
set nohlsearch        " no highlight search
set ignorecase        " ignore case in /...
set smartcase         " ...unless there is a capitol case char

set showcmd           " display incomplete commands
set showmode          " display mode

set cursorline        " always enable cursorline

set number            " line number
" set relativenumber    " relative line number

set nowrap            " don't wrap long lines
set linebreak         " break long lines at word bounderies in case I use wrap
set display+=lastline " show more of the line in case of wrap

set noeb                  " no error bell
set novb                  " no visual bell

" I don't use :browse
" set browsedir=buffer      " start browsing at dir of current buffer

set mouse=a               " enable mouse in normal, visual, insert and commnd-line mode
set mousemodel=extend     " exend selection on right click

set selectmode=           " use visual mode instead of select mode
set keymodel=             " don't start selection with shift+arrow or similar
set selection=inclusive   " allow selection of line break char (CR or LF or both)

" set softtabstop=4         " 4 spaces per tab key pressed
" set shiftwidth=4          " 4 spaces per indent level
" set expandtab             " use spaces instead of tab
set shiftround            " Round indent to multiple of 'shiftwidth'.

set nojoinspaces          " ein statt 2 spaces nach "saetzen" (nach . ! ?) bei J (normal mode Join command)

set winaltkeys=no         " disable menu with alt. necessary for <A-x> mappings

set splitright            " vertival split opens new window to the right
" }}}
" Statusline:
function! MyStatusline(full) abort " {{{
  "
  " first set rulerformat, then statusline
  " ruler is used in full screen mode after <F11>
  set rulerformat=%80(%=%#statusline#
        \\ %t%M%R%H%W
        \\ %{substitute(&ff\,'\\(.\\).\\+'\,'\\1'\,'')}
        \\ %{MyOpt(&fenc)}%{MyOpt(&ft)}
        \%02p%%
        \\ %)
  " line number, column and percent
  " \L%04l\ C%03v\ %02p%%
  "
  " now statusline
  setlocal statusline=%F                " Full path to the file in the buffer
  setlocal statusline+=%m               " Modified flag       [+] ; [-] if 'modifiable' is off
  setlocal statusline+=%r               " Readonly flag       [RO]
  setlocal statusline+=%h               " Help buffer flag    [help]
  setlocal statusline+=%w               " Preview window flag [Preview]
  setlocal statusline+=\                " a space
  setlocal statusline+=%=               " align right from here on
  if a:full
    " setlocal statusline+=\                " a space
    setlocal statusline+=%#Error#         " change coloring
    setlocal statusline+=%{get(b:\,'gitbranch'\,'')}
    setlocal statusline+=%#StatusLineNC#  " change coloring
    setlocal statusline+=\                " a space
    setlocal statusline+=%{substitute(&ff\,'\\(.\\).\\+'\,'\\1'\,'')}           " file format
    setlocal statusline+=\                " a space
    setlocal statusline+=%{MyOpt(&fenc)}  " fileencoding
    setlocal statusline+=%{MyOpt(&ft)}    " file type
    setlocal statusline+=%#StatusLine#    " change coloring
    setlocal statusline+=\ L%04l          " cursor position: 4 digits line   number
    setlocal statusline+=\ C%03v          " cursor position: 3 digits column number
    setlocal statusline+=\ %02p%%         " cursor position: percent of file
    setlocal statusline+=\ #%02n          " cursor position: 2 digits buffer number
  endif
  setlocal statusline+=\                " a space
  setlocal statusline+=%{VimBuddy()}    " fun
  if !a:full
    setlocal statusline+=..zzZZZ          " sleeping vimbuddy
  endif
  setlocal statusline+=\                " a space
  "
endfunction

function MyRuler() abort
  if &laststatus
    set laststatus=0 ruler 
  else
    set laststatus=2 noruler
  endif
endfunction

function MyOpt(opt) abort
  if a:opt != ""
    return a:opt . " "
  endif
  return ""
endfunction

function! StatuslineGitBranch() abort
  let b:gitbranch=""
  if &modifiable
    try
      let l:gitrevparse = system("git -C ".substitute(expand('%:p:h:S'),'\(\a\):','/\1','')." rev-parse --abbrev-ref HEAD")
      if !v:shell_error
        let b:gitbranch = " " . substitute(l:gitrevparse, '\( \|\n\)', '', 'g') . " "
      endif
    catch
    endtry
  endif
endfunction

augroup myStatusline
  autocmd!
  autocmd BufEnter,WinEnter * :call MyStatusline(1)
  autocmd BufLeave,WinLeave * :call MyStatusline(0)
  autocmd VimEnter,WinEnter,BufEnter d:/daten/scripts/git/* call StatuslineGitBranch()
augroup end
" }}}

" Rolodex:
function! ToggleRolodexTab() " {{{
  "This function turns Rolodex Vim on or off for the current tab
  "If turning off, it sets all windows to equal height
  if exists("t:rolodex_tab")
    unlet t:rolodex_tab
    call ClearRolodexSettings()
    execute "normal \<C-W>="
  else
    let t:rolodex_tab = 1
    call SetRolodexSettings()
  endif
endfunction
function! SetRolodexSettings()
  "This function set the Rolodex Vim settings and remembers the previous values for later
  if exists("t:rolodex_tab")
    let g:remember_ea  = &equalalways
    let g:remember_wmh = &winminheight
    let g:remember_wh  = &winheight
    let g:remember_wmw = &winminwidth
    let g:remember_ww  = &winwidth
    let g:remember_hh  = &helpheight
    set noequalalways winminheight=0 winheight=9999 winminwidth=0 winwidth=9999 helpheight=9999
  endif
endfunction
"This function clears the Rolodex Vim settings and restores the previous values
function! ClearRolodexSettings()
  if exists("g:remember_ea") " Assume if one exists they all will
    let &equalalways  = g:remember_ea
    let &winminheight = g:remember_wmh
    let &winheight    = g:remember_wh
    let &winminwidth  = g:remember_wmw
    let &winwidth     = g:remember_ww
    let &helpheight   = g:remember_hh
  endif
endfunction
" Change the settings whenever a new tab is selected
augroup vimrcEx
  autocmd TabEnter * call SetRolodexSettings()
  autocmd TabLeave * call ClearRolodexSettings()
augroup END
" }}}

" Relativenumber:
if exists("##ModeChanged")  " {{{
  augroup myRelativeNumber
    au!
    autocmd ModeChanged *:n   setlocal norelativenumber
    " das naechste funktioniert leider nicht.
    " autocmd ModeChanged *:no*   setlocal relativenumber
    autocmd ModeChanged *:[vV]   if &filetype!~'help' | setlocal relativenumber | endif
    " autocmd ModeChanged *:o setlocal relativenumber " operator pending mode scheint nicht zu funktionieren
    autocmd ModeChanged *:i   setlocal norelativenumber
    " autocmd ModeChanged *:R   setlocal norelativenumber " unnoetig
    " autocmd ModeChanged *:c   setlocal norelativenumber " functioniert nicht wg setlocal
    " autocmd ModeChanged *:tl  setlocal norelativenumber " keine Ahnung, benutz ich zZt nicht
    " beim umschalten in v, V oder ^V triggert CursorMoved wenn der Cursor auf einer Fold-Zeile ist, daher das if mode...
    " autocmd CursorMoved *     if mode()!~'[vV]' | setlocal norelativenumber | endif
  augroup END
  " command line mode
  nnoremap :  :setlocal relativenumber<cr>:
  " map operators to set relativenumber
  function <SID>My_cRelNum(a) abort
    if v:count > 0
      call feedkeys( v:count . a:a,'n')
      return
    endif
    setlocal relativenumber
    call feedkeys(a:a,'n')
  endfunction
  nnoremap c  :<c-u>call <SID>My_cRelNum('c')<cr>
  nnoremap d  :<c-u>call <SID>My_cRelNum('d')<cr>
  nnoremap y  :<c-u>call <SID>My_cRelNum('y')<cr>
  nnoremap g~ :<c-u>call <SID>My_cRelNum('g~')<cr>
  nnoremap gu :<c-u>call <SID>My_cRelNum('gu')<cr>
  nnoremap gU :<c-u>call <SID>My_cRelNum('gU')<cr>
  nnoremap !  :<c-u>call <SID>My_cRelNum('!')<cr>
  nnoremap =  :<c-u>call <SID>My_cRelNum('=')<cr>
  nnoremap gq :<c-u>call <SID>My_cRelNum('gq')<cr>
  nnoremap gw :<c-u>call <SID>My_cRelNum('gw')<cr>
  nnoremap g? :<c-u>call <SID>My_cRelNum('g?')<cr>
  nnoremap >  :<c-u>call <SID>My_cRelNum('>')<cr>
  nnoremap <  :<c-u>call <SID>My_cRelNum('<')<cr>
  nnoremap zf :<c-u>call <SID>My_cRelNum('zf')<cr>
  nnoremap g@ :<c-u>call <SID>My_cRelNum('g@')<cr>
  " commentary operator
  nmap gc :setlocal relativenumber<cr><Plug>Commentary
  xmap gc  <Plug>Commentary
  omap gc  <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
  nmap gcu <Plug>Commentary<Plug>Commentary
endif
" }}}

" Uniq:
command -range Uniq <line1>,<line2>s/\v^(.*)\n\zs(\1\n)+//

" Mappings:
" F Key Mappings: {{{
" get rid of trailing white spaces and tabs; use two spaces instead of tab
nnoremap <F5> :%s/\s\+$//<CR>:%s/\t/  /g<CR>``
" indent the whole file
nnoremap <F6> gg=G``zz
" toggle Rolodex
nnoremap <F8> :call ToggleRolodexTab()<cr>
" Identify the syntax highlighting group used at the cursor
nnoremap <F9> :echo "hi<" .  synIDattr(            synID(line("."),col("."),1)  ,"name") . '> trans<'
           \ .               synIDattr(            synID(line("."),col("."),0)  ,"name") . "> lo<"
           \ .               synIDattr(synIDtrans( synID(line("."),col("."),1) ),"name") . ">"<CR>
" fun
nnoremap <silent> <F10> :noautocmd Matrix<CR>
" fullscreen shell.vim; work around bug where the statusline disappears
nnoremap <silent> <F11> :Fullscreen<CR>:sleep 51m<CR>:call MyStatusline(1)<cr>:call MyRuler()<cr>
nnoremap <silent> <S-F11> :if &guioptions=~'\Cm'<bar>set guioptions-=m<bar>set guioptions-=T<bar>set guioptions-=l<bar>set guioptions-=R<bar>else<bar>set guioptions+=m<bar>set guioptions+=T<bar>set guioptions+=l<bar>set guioptions+=R<bar>endif<cr>
" show buffers and start buffer command
nnoremap <F12> :ls<cr>:buffer 
" }}}
" Clever Tab: {{{
function! CleverTab()
  " if strpart( getline('.'), 0, col('.')-1 ) !~ '\(^\s*\|\s\)$'
  if getline('.')[col('.') - 2] =~ '\k'
    return "\<C-P>"
  endif
  return "\<Tab>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <S-Tab> <C-N>
" }}}
" Indent Text Object: {{{
function! IndTxtObj(inner)
  let l:curline  = line(".")
  let l:lastline = line("$")
  let l:i        = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  if getline(".")!~'^\s*$'
    while (getline('.')=~'^\s*$' || indent(line('.'))>=l:i) && line('.')>1
      normal! k
    endwhile
    if a:inner==1 && indent(line('.'))<l:i
      normal! j
    endif
    if getline(".")=~'^\s*$'
      normal! j
    endif
    normal! V
    exec "normal! ".l:curline."gg"
    while (getline('.')=~'^\s*$' || indent(line('.'))>=l:i) && line('.')<l:lastline
      normal! j
    endwhile
    if a:inner==1 && indent(line('.'))<l:i
      normal! k
    endif
    if getline(".")=~'^\s*$'
      normal! k
    endif
  endif
endfunction
xnoremap <silent>ai :<C-u>call IndTxtObj(0)<CR>
xnoremap <silent>ii :<C-u>call IndTxtObj(1)<CR>
onoremap <silent>ai :<C-u>call IndTxtObj(0)<CR>
onoremap <silent>ii :<C-u>call IndTxtObj(1)<CR>
" }}}
" Other Mappings: {{{
" don't break undo and repeat with left/right arrow in insert mode
inoremap <left> <c-g>U<left>
inoremap <right> <c-g>U<right>
" make Y similar to C, and D. Original Y is already yy
nnoremap Y y$

" center when searching next/previous
nnoremap * *zz
nnoremap # #zz
nnoremap n nzz
nnoremap N Nzz
" center when going to line #
nnoremap gg ggzz
" center when moving to previews/next chapter
nnoremap { {zz
nnoremap } }zz
" center when moving to previews/next diff
nnoremap [c [czz
nnoremap ]c ]czz

" my modification of zmappings
nnoremap zl 10zl
nnoremap zh 10zh

" make use of the arrow keys
nnoremap <LEFT>   :bp<CR>
nnoremap <RIGHT>  :bn<CR>

" avoid <Left> <Right> - select previous/next match. See :he wildmenu
cnoremap <Left>   <Space><BS><Left>
cnoremap <Right>  <Space><BS><Right>

" use * on everything in visual mode
" See http://vim.wikia.com/wiki/Search_for_visually_selected_text
xnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
xnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" automagically generate vimgrep line on ; in visual mode
xnoremap <A-;> y:<C-U>vimgrep /\V<c-r>=escape(@@,"/\\")<CR>/j <C-R>=join(split(&path, ","), "/* ")<CR>/*
xnoremap ; :<C-U>vimgrep /\c\v<<c-r><c-w>>/j <C-R>=join(split(&path, ","), "/* ")<CR>/*

" Increment visualy selected numbers; see :he increment
xnoremap <c-a> :IncN<CR>

" DON'T use this, use gu{motion}, gU{motion} and g~{motion}
" change current word to upper/lower case in insert mode
" inoremap <c-u> <esc>viwUea
" inoremap <c-l> <esc>viwuea
" change current word to upper/lower case in normal mode
" nnoremap <c-u> viwU
" nnoremap <c-l> viwu
" change current visual selection to uppe/lower case since I cant remember u and U
" xnoremap <c-u> U
" xnoremap <c-l> u

" move around windows
" nnoremap <silent> <A-h> <C-W>h
" nnoremap <silent> <A-j> <C-W>j
" nnoremap <silent> <A-k> <C-W>k
" nnoremap <silent> <A-l> <C-W>l
" this works better with MyRuler()
nnoremap <silent> <A-h> :wincmd h<cr>
nnoremap <silent> <A-j> :wincmd j<cr>
nnoremap <silent> <A-k> :wincmd k<cr>
nnoremap <silent> <A-l> :wincmd l<cr>
" move windows around
nmap <A-Left>   <plug>(tradewinds-h)
nmap <A-Down>   <plug>(tradewinds-j)
nmap <A-Up>     <plug>(tradewinds-k)
nmap <A-Right>  <plug>(tradewinds-l)
" change window size
nnoremap <silent> <C-S-H>      10<C-W><
nnoremap <silent> <C-S-J>       5<C-W>-
nnoremap <silent> <C-S-K>       5<C-W>+
nnoremap <silent> <C-S-L>      10<C-W>>

" Swap v and CTRL-V, because Block mode is more useful that Visual mode
nnoremap    v   <C-V>
nnoremap <C-V>     v
xnoremap    v   <C-V>
xnoremap <C-V>     v

" dragvisuals.vim
xmap <expr> <Left>  DVB_Drag('left')
xmap <expr> <Down>  DVB_Drag('down')
xmap <expr> <Up>    DVB_Drag('up')
xmap <expr> <Right> DVB_Drag('right')
" vmap  <expr>  D DVB_Duplicate() " default

" short for :Align
nnoremap <leader>a    :Align! =p1P1l: 
xnoremap <leader>a    :Align! =p1P1l: 
" scroll bind
command! BindBoth     set   scrollbind | wincmd p | set   scrollbind | wincmd p
command! BindBothOff  set noscrollbind | wincmd p | set noscrollbind | wincmd p
nnoremap <leader>bon :BindBoth<CR>
nnoremap <leader>bof :BindBothOff<CR>

" also go to last column, not only line on ''
nnoremap ' `
" save with ctrl+s
nnoremap <c-s> :update<cr>
" help
nnoremap <leader>h :he<cr><c-w>L:help 
" edit .vimrc
nnoremap <leader>e :edit $HOME/.vim/vimrc<cr>
" edit mylearnvim.txt
nnoremap <leader>l :edit $HOME/.vim/mylearnvim.md<cr>
" <leader><leader> is more convenient than <C-^> or <C-6>
nnoremap <leader><leader> <C-^>
" Close all other splits
nnoremap <leader>o :only<cr>

" my auto insert closing pair
inoremap ' ''<c-g>U<left>
inoremap " ""<c-g>U<left>
inoremap ( ()<c-g>U<left>
inoremap [ []<c-g>U<left>
inoremap { {}<c-g>U<left>
" }}}

" My Plugin Settings:
" KnoP Settings: {{{
" let g:knopLhsQuickfix=0
let g:knopRhsQuickfix=1
let g:knopVerbose=0
" let g:knopNoVerbose=0
" let g:knopShortenQFPath=0
" }}}
" Rapid For VIM: {{{
" look also into ~/vimfiles/after/ftplugin/rapid.vim
" augroup RapidAutoForm
"   au!
"   au User RapidAutoFormPost exec "normal {"
" augroup END
" let g:rapidEndwiseUpperCase=1
" let g:rapidGroupName=0
" let g:rapidNewStyleIndent=1
" let g:rapidNoCommentIndent=0 " undokumentiert
" let g:rapidCommentIndent=0
" let g:rapidCommentTextObject=0
" let g:rapidFormatComments=1
" let g:rapidAutoComment=0
" let g:rapidAutoCorrCfgLineEnd=0
" let g:rapidMoveAroundKeyMap=2
" let g:rapidGoDefinitionKeyMap=1
" let g:rapidListDefKeyMap=1
" let g:rapidListUsageKeyMap=1
" let g:rapidConcealStructsKeyMap=1 " deprecated
" let g:rapidConcealStructKeyMap=1
let g:rapidConcealStructs=0
" let g:rapidAutoFormKeyMap=1
" let g:rapidCompleteStd = 0
let g:rapidCompleteCustom = [
      \'TASK1/PROGMOD/Service.mod', 
      \'TASK3/PROGMOD/CyclicProg.mod',
      \'TASK1/PROGMOD/MainRob1.mod',
      \'TASK1/PROGMOD/MainRob2.mod',
      \'TASK1/PROGMOD/MainRob3.mod',
      \'TASK1/PROGMOD/Admin.mod',
      \'TASK1/PROGMOD/Berechnung.mod',
      \'TASK1/PROGMOD/Blisterfunktionen.mod',
      \'TASK1/PROGMOD/Daten.mod',
      \'TASK1/PROGMOD/Greifer.mod',
      \'TASK1/PROGMOD/KLT_DATEN.mod',
      \'TASK1/PROGMOD/Gestell_DATEN.mod',
      \'TASK1/SYSMOD/mvBefehle.sys',
      \'TASK1/SYSMOD/Befehle.sys']
" let g:rapidPathToBodyFiles='d:\daten\scripts\vim_resource\rapid resource\'
" let g:rapidNoHighLink=1
" let g:rapidShowError=0
" let g:rapidNoIndent=0
" let g:rapidNoSpaceIndent=1
let g:rapidSpaceIndent=0
" let g:rapidNoPath=1
" let g:rapidPath=0
" let g:rapidNoVerbose=1 " siehe oben g:knop...
" let g:rapidRhsQuickfix " siehe oben g:knop...
" let g:rapidLhsQuickfix " siehe oben g:knop...
" }}}
" Krl For Vim: {{{
" look also into ~/vimfiles/after/ftplugin/krl.vim
" augroup KrlAutoForm
"   au!
"   au User KrlAutoFormPost exec "normal {"
" augroup END
" let g:krlEndwiseUpperCase=1
" let g:krlShortenQFPath=0
" let g:krlNoCommentIndent=0
" let g:krlIndentBetweenDef = 0
" let g:krlCommentIndent=1
" let g:krlCommentTextObject=0
" let g:krlFormatComments=0
" let g:krlAutoComment=0
" let g:krlMoveAroundKeyMap=0
" let g:krlGoDefinitionKeyMap=1
" nnoremap gd gd
" nmap ggd <plug>KrlGoDef
" let g:krlListDefKeyMap=1
" nnoremap <leader>f gd
" let g:krlListUsageKeyMap=1
" let g:krlAutoFormKeyMap=1
" let g:krlCompleteStd = 0
let g:krlCompleteCustom = [
      \'R1/Program/sonstiges/acol.src', 
      \'R1/System/bas.src', 
      \'R1/Graeff TP/global_var.dat', 
      \'R1/Graeff TP/mymessage.src', 
      \'R1/Graeff TP/mymessage.dat', 
      \'R1/Graeff TP/global_fct.src']
" let g:krlPathToBodyFiles='d:\daten\scripts\vim_resource\krl resource\'
" let g:krlAutoFormUpperCase=1
" let g:krlGroupName=0
" let g:krlNoHighLink=0
" let g:krlNoHighlight=1
" let g:krlShowError=1
" let g:krlFoldKeyMap=1 " deprecated
" let g:krlFoldingKeyMap=1
" let g:krlCloseFolds=1
let g:krlFoldLevel=2
" let g:krlFoldMethodSyntax=0
" let g:krlNoIndent=0
" let g:krlNoSpaceIndent=0
" let g:krlSpaceIndent=0
" let g:krlKeyWord=0
" let g:krlNoKeyWord=0
" let g:krlNoPath=0
" let g:krlNoVerbose=1 " siehe oben g:knop...
" let g:krlRhsQuickfix " siehe oben g:knop...
" let g:krlLhsQuickfix " siehe oben g:knop...
" }}}

" Colorscheme:
" colorscheme: {{{

" let g:rapidGroupName=0
" let g:krlGroupName=0

" colorscheme anokha
" hi ColorColumn ctermbg=0 guibg=#001010
" hi NonText     guifg=#336633   guibg=#003333   gui=NONE

" colorscheme ayu

" colorscheme desert-night

" colorscheme despacio

" colorscheme fahrenheit

" colorscheme falcon

" colorscheme flatlandia

" colorscheme flattened_dark          "  ***

" colorscheme frictionless

" colorscheme goodwolf                "  ***

" colorscheme hybrid

" colorscheme lizard

" colorscheme mustang
" hi ColorColumn ctermbg=0 guibg=#101010

" colorscheme nordisk

" colorscheme PerfectDark
" hi ColorColumn ctermbg=0 guibg=#404040
" highlight Folded guifg=#999999 guibg=#222222 gui=NONE 

" colorscheme petrel
" hi  ColorColumn   ctermbg=0  guibg=#3d454b  gui=NONE
" hi  NonText       cterm=NONE ctermfg=11  guibg=#3d454b   guifg=#6d767d  gui=NONE

" colorscheme quantum

" colorscheme robotstudio

" colorscheme scheakur

" let g:solarized_style    = "dark"
" let g:solarized_contrast = "high"
" let g:solarized_italic   = 0
" let g:solarized_bold     = 0
" colorscheme solarized               "  ***

" colorscheme solarized8_dark_high    "  ***

" colorscheme sorcerer

" colorscheme stormpetrel

" colorscheme tortus

colorscheme tortusless              "  ***
" highlight Typedef           guibg=black         guifg=lightmagenta       gui=NONE

" colorscheme fogbell " very nice monochrome colorscheme!"
"
" colorscheme murphy

" colorscheme true-monochrome         "  ***
" hi ColorColumn ctermbg=0 guibg=#1c1c1c

" colorscheme zazen                   "  ***

" }}}

" Other Plugin Settings:
" Netrw: {{{
let g:netrw_preview      = 1    " position of the preview window opened with p
let g:netrw_alto         = 0    " position of the edit window opened with o
let g:netrw_altv         = 0    " position of the edit window opened with v
let g:netrw_liststyle    = 3    " tree view
let g:netrw_winsize      = 50   " size in % of an opened window with o or v
let g:netrw_browse_split = 0    " reuse current window
" }}}
" Autodate: {{{
" let g:plugin_autodate_disable = 1 " not present enables, any value disables
let g:autodate_keyword_post   = '$'
let g:autodate_format         = '%d. %3m %Y'
" }}}

" vim:sw=2 sts=2 et fdm=marker fmr={{{,}}}
