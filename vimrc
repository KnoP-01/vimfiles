" .vimrc (C) Patrick Meiser-Knosowski aka KnoP

" don't copy this if you don't know what you are doing
" and think about the poor pandas if you do!

" {{{ init
" Vim Rather Then Vi
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

  " vim script test framework
  Plug 'junegunn/vader.vim'

  Plug 'KnoP-01/tortus'
  Plug 'KnoP-01/vimbuddy'
  Plug 'KnoP-01/vim-tp'
  Plug 'KnoP-01/vim-karel'
  Plug 'KnoP-01/DrChipsCecutil'
  Plug 'KnoP-01/DrChipsAlign'
  let g:loaded_AlignMapsPlugin=1  " AlignMaps.vim; get rid of maps from AlignMapsPlugin
  Plug 'KnoP-01/DrChipsVis'

  " motoman plugin"
  " Plug 'matthijsk/motoman-inform-vim-syntax'
  Plug 'KnoP-01/motoman-inform-vim-syntax'

  " full screen mode for windows
  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-shell'
  let g:shell_mappings_enabled          = 0
  let g:shell_fullscreen_always_on_top  = 0

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

  " Plug 'vim-scripts/RelOps'
  " let g:relops_check_for_nu = 1
  " let g:relops_mappings = ['gc']
  " Plug 'vim-scripts/increment.vim--Avadhanula'
  Plug 'mMontu/increment.vim--Avadhanula'

  " compare character wise with vimdiff
  Plug 'rickhowe/diffchar.vim'

  " markdown
  Plug 'godlygeek/tabular'
  let g:vim_markdown_folding_disabled = 1
  Plug 'plasticboy/vim-markdown'
  " let g:instant_markdown_browser = "firefox --new-window"
  " let g:instant_markdown_python = 1
  " let g:instant_markdown_logfile = '.\instant_markdown.log'
  " Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

  " switch between true/false...
  Plug 'AndrewRadev/switch.vim'
  " let g:switch_mapping = 'gs' " this one is default
  " let g:switch_mapping = '' " disabled b/c <plug> see below
  let g:switch_reverse_mapping = 'ga'
  " nnoremap <silent> <plug>SwitchFwd :Switch<cr>
  " nnoremap <silent> <plug>SwitchBwd :SwitchReverse<cr>
  " nmap gs <plug>SwitchFwd
  " nmap ga <plug>SwitchBwd

call plug#end()
" PlugUpdate
command! MyPlugUpdate   :set statusline=%F%m%r%h%w shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugUpdate
" PlugInstall
command! MyPlugInstall  :set statusline=%F%m%r%h%w shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugInstall
" PlugClean
command! MyPlugInstall  :set statusline=%F%m%r%h%w shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugClean
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
  " autocmd BufEnter,WinEnter *                           setlocal    cursorline
  " autocmd BufLeave,WinLeave *                           setlocal  nocursorline
  autocmd BufEnter,WinEnter * if &filetype !=# 'help' | setlocal    relativenumber | endif
  autocmd BufLeave,WinLeave * if &filetype !=# 'help' | setlocal  norelativenumber | endif

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " turbo risk pascal files
  autocmd BufNewFile,BufRead *.trp set syntax=TR_Pascal

  " Continue editing where left unless the position is invalid
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

augroup END
" }}}

" Options:
" Other Options: {{{

" better diff
if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif

" 'wildmenu'
set wildchar=<Tab> wildcharm=<C-Z> wildmenu wildmode=full

" set listchars=tab:»·,trail:·,eol:$
set listchars=nbsp:~,tab:>-,trail:.,eol:$

set backspace=indent,eol,start    " allow backspacing over everything in insert mode

set diffopt=filler,icase,iwhite   " settings for diff mode: keep window lines synchronised, ignore case, ignore different amount of white spaces

set backup            " write a backup.file~
" set directory-=.      " redirect .swp files to C:\Users\<user>\AppData\Local\Temp

if has("win32")
  set shell=c:/apps/gitforwin/bin/bash.exe " use git for windows bash
  set shellcmdflag=-c
  " set shellquote="\""
  " set shellxquote="\""
  set shellslash
  set guioptions+=!     " don't open cmd.exe-window on windows in case of :!
endif

set guioptions+=a         " put visually selected text into * register (gui only)
set clipboard=autoselect  " same for terminals

set guioptions-=r     " no right scroll bar. Siehe <S-F11> unten
set guioptions-=L     " no left scroll bar in case of vertical split
" set guioptions+=l     " left scroll bar
" set guioptions+=R     " right scroll bar in case of vertical split

set guioptions-=m    " kein Menu per default. Siehe <S-F11> unten
set guioptions-=T    " keine Toolbar per default. Siehe <S-F11> unten

set nrformats-=octal  " don't use octal in case of leading 0

set scrolloff=3       " scroll offset at top or bottom
set sidescrolloff=5   " scroll offset at left or right

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
set relativenumber    " relative line number

set nowrap            " don't wrap long lines
set linebreak         " break long lines at word bounderies in case I use wrap
set display+=lastline " show more of the line in case of wrap

set noeb                  " no error bell
set novb                  " no visual bell

" I don't use browse
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

set nojoinspaces          " ein statt 2 spaces nach "saetzen" (nach . ! ?)

set winaltkeys=no         " disable menu with alt. necessary for <A-x> mappings

set splitright            " vertival split opens new window to the right
" }}}

" Statusline:
function! MyStatusline(full) " {{{
  setlocal statusline=%F                " Path to the file in the buffer, as typed or relative to current directory
  setlocal statusline+=%m               " Modified flag       [+] ; [-] if 'modifiable' is off
  setlocal statusline+=%r               " Readonly flag       [RO]
  setlocal statusline+=%h               " Help buffer flag    [help]
  setlocal statusline+=%w               " Preview window flag [Preview]
  if a:full
    setlocal statusline+=%=               " align right from here on
    setlocal statusline+=%#Error#         " change coloring
    setlocal statusline+=%{b:gitbranch}
    setlocal statusline+=%#StatusLineNC#  " change coloring
    setlocal statusline+=\                " a space
    setlocal statusline+=%{substitute(&ff\,'\\(.\\).\\+'\,'\\1'\,'')}           " file format
    setlocal statusline+=\ %{&enc}        " encoding
    setlocal statusline+=\ %{&ft}         " file type
    setlocal statusline+=\                " a space
    setlocal statusline+=%#StatusLine#   " change coloring
    " setlocal statusline+=%#ToDo#          " change coloring
    setlocal statusline+=\ L%04l          " cursor position: 4 digits line   number
    setlocal statusline+=\ C%03v          " cursor position: 3 digits column number
    setlocal statusline+=\ %02p%%         " cursor position: percent of file
    setlocal statusline+=\ #%02n          " cursor position: 2 digits buffer number
    setlocal statusline+=\                " a space
    " setlocal statusline+=%#SpecialChar#   " change coloring
    setlocal statusline+=%{VimBuddy()}    " fun
    setlocal statusline+=\                " a space
  endif
endfunction

function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    try
      let l:gitrevparse = system("git -C ".substitute(expand('%:p:h:S'),'\(\a\):','/\1','')." rev-parse --abbrev-ref HEAD")
      " let l:gitrevparse = system('git -C /d/daten/scripts/git/knop-01/rapid-for-vim rev-parse --abbrev-ref HEAD')
      if !v:shell_error
        let b:gitbranch = " " . substitute(l:gitrevparse, '\( \|\n\)', '', 'g') . " "
      endif
    catch
    endtry
  endif
endfunction

" call MyStatusline(1)
augroup myStatusline
  autocmd!
  autocmd BufEnter,WinEnter * :call MyStatusline(1)
  autocmd BufLeave,WinLeave * :call MyStatusline(0)
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
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
nnoremap <silent> <F11> :Fullscreen<CR>:sleep 51m<CR>:call MyStatusline(1)<cr>
nnoremap <silent> <S-F11> :if &guioptions=~'\Cm'<bar>set guioptions-=m<bar>set guioptions-=T<bar>set guioptions-=r<bar>else<bar>set guioptions+=m<bar>set guioptions+=T<bar>set guioptions+=r<bar>endif<cr>
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
" make use of ctrl-q
nnoremap <c-q> :qa<cr>

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

" auto create vimgrep line on ; in visual mode
xnoremap ; y:<C-U>vimgrep /\V<c-r>=escape(@@,"/\\")<CR>/j <C-R>=join(split(&path, ","), "/* ")<CR>/*

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
nnoremap <silent> <A-h> <C-W>h
nnoremap <silent> <A-j> <C-W>j
nnoremap <silent> <A-k> <C-W>k
nnoremap <silent> <A-l> <C-W>l
" move window around
nmap <A-Left>   <plug>(tradewinds-h)
nmap <A-Down>   <plug>(tradewinds-j)
nmap <A-Up>     <plug>(tradewinds-k)
nmap <A-Right>  <plug>(tradewinds-l)
" change window size
nnoremap <silent> <A-C-Left>   10<C-W><
nnoremap <silent> <A-C-Down>    5<C-W>-
nnoremap <silent> <A-C-Up>      5<C-W>+
nnoremap <silent> <A-C-Right>  10<C-W>>

" Swap v and CTRL-V, because Block mode is more useful that Visual mode
nnoremap    v   <C-V>
nnoremap <C-V>     v
xnoremap    v   <C-V>
xnoremap <C-V>     v

" dragvisuals.vim
xmap <expr> <Left>  DVB_Drag('left')
xmap <expr> <C-S-H> DVB_Drag('left')
xmap <expr> <Down>  DVB_Drag('down')
xmap <expr> <C-S-J> DVB_Drag('down')
xmap <expr> <Up>    DVB_Drag('up')
xmap <expr> <C-S-K> DVB_Drag('up')
xmap <expr> <Right> DVB_Drag('right')
xmap <expr> <C-S-L> DVB_Drag('right')
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
" let g:rapidNoCommentIndent=0 " undokumentiert
let g:rapidCommentIndent=0
" let g:rapidCommentTextObject=0
" let g:rapidFormatComments=1
" let g:rapidAutoComment=0
" let g:rapidAutoCorrCfgLineEnd=1
" let g:rapidMoveAroundKeyMap=2
" let g:rapidGoDefinitionKeyMap=1
" let g:rapidListDefKeyMap=1
" let g:rapidListUsageKeyMap=1
" let g:rapidConcealStructsKeyMap=1 " deprecated
" let g:rapidConcealStructKeyMap=1
let g:rapidConcealStructs=2
" let g:rapidAutoFormKeyMap=1
" let g:rapidCompleteStd = 0
let g:rapidCompleteCustom = [
      \'TASK1/PROGMOD/Service.mod', 
      \'TASK3/PROGMOD/CyclicProg.mod',
      \'TASK1/PROGMOD/MainRob1.mod',
      \'TASK1/PROGMOD/MainRob2.mod',
      \'TASK1/PROGMOD/MainRob3.mod']
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
let g:krlCommentIndent=1
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
"
" colorscheme tortus
colorscheme tortusless
" colorscheme highlight
" colorscheme robotstudio
" colorscheme vulpo
" 
" colorscheme ir_black
"
" colorscheme mustang
" colorscheme anokha
" colorscheme BusyBee
" colorscheme edark
" colorscheme falcon
" colorscheme flatlandia
" colorscheme flattened_dark
" colorscheme frictionless
"
" colorscheme seoul256
" let g:seoul256_background = 233
"
" colorscheme gruvbox
" highlight Cursor guifg=#00FF00 ctermfg=green
" highlight Folded guifg=#8e9200 ctermfg=106
" highlight link krlMovement   Folded
" highlight link rapidMovement Folded
"
" colorscheme holokai
" colorscheme jellybeans
" colorscheme lizard
" colorscheme midnight2
" colorscheme mythos
" colorscheme neodark
" colorscheme oceandeep
" colorscheme petrel
" colorscheme papercolor
" let g:PaperColor_Theme_Options = {
"   \   'theme': {
"   \     'default': {
"   \       'allow_bold': 0
"   \      ,'allow_italic': 0
"   \     }
"   \   }
"   \ }
" highlight link Folded Statement
" colorscheme rdark
" colorscheme scheakur
" colorscheme seti
" colorscheme solarized
" colorscheme solarized8_dark_flat
" colorscheme stormpetrel
" colorscheme true-monochrome
" colorscheme tortex
" colorscheme vitamins
" colorscheme vividchalk
" colorscheme vydark
" colorscheme wombat256mod
" colorscheme zazen
" highlight Todo          guibg=#404040   guifg=white 
" colorscheme zendnb
" colorscheme znake
" }}}

" Other Plugin Settings:
" Netrw: {{{
let g:netrw_winsize = 25        " sets the width to 25% of the page
let g:netrw_browse_split = 0    " reuse current window
" }}}
" Autodate: {{{
" let g:plugin_autodate_disable = 1 " not present enables, any value disables
let g:autodate_keyword_post   = '$'
let b:autodate_format         = '%d. %3m %Y'
" }}}

" vim:sw=2 sts=2 et fdm=marker fmr={{{,}}}
