" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set langmenu=none
" language en

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" matchit
packadd! matchit

" My vim-plug
command! MyPlugUpdate :call PlugUpdateWrapper()
function! PlugUpdateWrapper()
  set statusline=%F%m%r%h%w
  PlugUpdate
endfunction
command! MyPlugInstall :call PlugInstallWrapper()
function! PlugInstallWrapper()
  set statusline=%F%m%r%h%w
  PlugInstall
endfunction
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

  " Make sure you use single quotes

  " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
  " Plug 'junegunn/vim-easy-align'
  Plug 'KnoP-01/tortus'
  Plug 'KnoP-01/vimbuddy'

  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-shell'

  Plug 'tpope/vim-vinegar'
  Plug 'tpope/vim-commentary'

  Plug 'romainl/vim-qf'

  Plug 'uguu-org/vim-matrix-screensaver'

  Plug 'andymass/vim-tradewinds'

  Plug 'vim-scripts/increment.vim--Avadhanula'

  " Any valid git URL is allowed
  " Plug 'https://github.com/junegunn/vim-github-dashboard.git'

  " Multiple Plug commands can be written in a single line using | separators
  " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

  " On-demand loading " normalerweise nicht notwendig
  " Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  " Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

  " Using a non-master branch
  " Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

  " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
  " Plug 'fatih/vim-go', { 'tag': '*' }

  " Plugin options
  " Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

  " Plugin outside ~/.vim/plugged with post-update hook
  " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  " Unmanaged plugin (manually installed and updated)
  " Plug '~/my-prototype-plugin'

" Initialize plugin system
call plug#end()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

" left scroll bar
" let &guioptions = substitute(&guioptions, 'L', 'l', 'g')
" let &guioptions = substitute(&guioptions, 'r', 'R', 'g')
set guioptions-=L
set guioptions+=l
set guioptions-=r
set guioptions+=R
set guioptions+=a

" Switch syntax highlighting on, when the terminal has colors
" for some unknown reason my windows git-bash does not like syntax on at this position?! So I excluded its &term (xterm)
if &t_Co > 2 && &term!~'xterm-256color' || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcRelNum
    " relativenumber and cursorline only in current window
    autocmd BufEnter,WinEnter,InsertLeave * setlocal cursorline
    autocmd BufEnter,WinEnter,InsertLeave *
          \ if &filetype !=# 'help' | setlocal relativenumber | endif
    autocmd BufLeave,WinLeave,InsertEnter * setlocal nocursorline
    autocmd BufLeave,WinLeave,InsertEnter *
          \ if &filetype !=# 'help' | setlocal norelativenumber | endif
  augroup END

  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal g`\"" |
          \ endif

    " turbo risk pascal files
    au BufNewFile,BufRead *.trp set syntax=TR_Pascal

  augroup END

else " has("autocmd")

  set autoindent		" always set autoindenting on

endif " has("autocmd")

set scrolloff=0
set history=50		" keep 50 lines of command line history

set laststatus=2 " always show status line

set incsearch		" do incremental searching
set nohlsearch
set ignorecase
set smartcase

set showcmd		" display incomplete commands
set showmode
set cursorline

set number
set relativenumber

set nowrap
set linebreak " in case I use wrap

set diffopt=filler,icase,iwhite

set noeb  " no error bell
set novb  " no visual bell

" security
" set modelines=0

set browsedir=buffer " start browsing at dir of current buffer

" With the mouse:  ":set mouse=a" to enable the mouse (in xterm or GUI).
set mouse=a
set selectmode=
set mousemodel=extend
set keymodel=
set selection=inclusive

set shiftround

" set listchars=tab:ª∑,trail:∑,eol:$
set listchars=nbsp:~,tab:>-,trail:.,eol:$

set nojoinspaces " ein statt 2 spaces nach "saetzen" (nach . ! ?)

" center when searching next
nnoremap n nzz
" center when searching previous
nnoremap N Nzz
" center when going to line #
nnoremap gg ggzz
" center when moving to previews/next chapter
nnoremap { {zz
nnoremap } }zz
" center when moving to previews/next diff
nnoremap [c [czz
nnoremap ]c ]czz

" make use of the arrow keys
nnoremap <LEFT> :bp<CR>
nnoremap <RIGHT> :bn<CR>

" nnoremap <F4> perl -e oder so... ab sofort in ~\vimfiles\after\ftplugin\perl.vim
nnoremap <F5> :%s/\s\+$//<CR>'':%s/\t/\ \ /g<CR>''
nnoremap <F6> gg=G``zz

" easier buffer handling
" avoid <Left> <Right> - select previous/next match. See :he wildmenu
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>
set wildchar=<Tab> wildcharm=<C-Z> wildmenu wildmode=full
nnoremap <F8> :ls<cr>:buffer 

" Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" fun
nnoremap <silent> <F10> :set norelativenumber nonumber\|Matrix<CR>

" fullscreen on <F11> shell.vim
let g:shell_mappings_enabled = 0
let g:shell_fullscreen_always_on_top=0
" work around bug where the statusline disappears
nnoremap <silent> <F11> :Fullscreen<CR>:sleep 51m<CR>:set statusline=%F%m%r%h%w\ \ \ [%{&ff}\ %{&enc}]\ \ \ [Pos=%04l\/%L,%04v]\ \ \ [Buf:#%n]\ \ \ %{VimBuddy()}<CR>
                                                      set statusline=%F%m%r%h%w\ \ \ [%{&ff}\ %{&enc}]\ \ \ [Pos=%04l\/%L,%04v]\ \ \ [Buf:#%n]\ \ \ %{VimBuddy()}
"

nnoremap <F12> :Vex<CR>

" Atom \V sets following pattern to "very nomagic", i.e. only the backslash
" has special meaning.
" As a search pattern we insert an expression (= register) that
" calls the 'escape()' function on the unnamed register content '@@',
" and escapes the backslash and the character that still has a special
" meaning in the search command (/|?, respectively).
" This works well even with <Tab> (no need to change ^I into \t),
" but not with a linebreak, which must be changed from ^M to \n.
" This is done with the substitute() function.
" See http://vim.wikia.com/wiki/Search_for_visually_selected_text
xnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
xnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>

" indent text object
function! IndTxtObj(inner)
  let l:curline = line(".")
  let l:lastline = line("$")
  let l:i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
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

" function text object
" vnoremap <silent>af :<C-U>silent normal [[V][<CR>
" vnoremap <silent>if :<C-U>silent normal [[jV][k<CR>
" omap <silent>af :normal Vaf<CR>
" omap <silent>if :normal Vif<CR>

" :Inc, :IncN and :IncL
" 1. Inc : generates a column of increasing numbers with RIGHT  alignment.
" 2. IncN: generates a column of increasing numbers with NO     alignment.
" 3. IncL: generates a column of increasing numbers with LEFT   alignment
vnoremap <c-a> :IncN<CR>

" more mappings
nnoremap ' `
" change current word to upper/lower case in insert mode
inoremap <c-u> <esc>viwUea
inoremap <c-l> <esc>viwuea
" change current word to uppe/lower case in noemal mode
nnoremap <c-u> viwU
nnoremap <c-l> viwu

" disable menu with alt. nessecary for the following
set winaltkeys=no
" move from win to win more easyly
nnoremap <silent> <A-h> <C-W>h
nnoremap <silent> <A-j> <C-W>j
nnoremap <silent> <A-k> <C-W>k
nnoremap <silent> <A-l> <C-W>l
" move windows more easyly (andymass/vim-tradewinds)
let g:tradewinds_no_maps = 1
nmap <A-H> <plug>(tradewinds-h)
nmap <A-J> <plug>(tradewinds-j)
nmap <A-K> <plug>(tradewinds-k)
nmap <A-L> <plug>(tradewinds-l)

" leader mappings
let mapleader = " "
let maplocalleader = " "
" help
nnoremap <leader>h :he<cr><c-w>L:help 
" edit .vimrc
nnoremap <leader>e :edit $HOME/.vim/vimrc<cr>

" my modification of zmappings
nnoremap zl 16zl
nnoremap zh 16zh

" redirect .swp files to C:\Users\<user>\AppData\Local\Temp
" set directory-=.

" my modification of <c-e> and <c-y>
" nnoremap <c-e> <c-e><c-e><c-e><c-e><c-e>  
" nnoremap <c-y> <c-y><c-y><c-y><c-y><c-y>  
" use zb, zt and zz instead

" My plugin mappings and settings
" let g:knopLhsQuickfix=0
let g:knopRhsQuickfix=1
" let g:knopVerbose=0
" let g:knopVerbose=1
" let g:knopNoVerbose=0
" let g:knopShortenQFPath=0

" Note: rapid options
" look also into ~/vimfiles/after/ftplugin/rapid.vim
" let g:rapidNoCommentIndent=0 " undokumentiert
let g:rapidAutoCorrCfgLineEnd=1
let g:rapidMoveAroundKeyMap=2
" let g:rapidGoDefinitionKeyMap=1
" let g:rapidListDefKeyMap=1
" let g:rapidListUsageKeyMap=1
" let g:rapidConcealStructsKeyMap=1 " deprecated
" let g:rapidConcealStructKeyMap=1
let g:rapidConcealStructs=1
let g:rapidAutoFormKeyMap=1
" let g:rapidPathToBodyFiles='d:\daten\scripts\vim_resource\rapid resource\'
let g:rapidNoHighLink=1
let g:rapidShowError=1
let g:rapidFormatComments=1
" let g:rapidAutoComment=0
" let g:rapidNoIndent=0
" let g:rapidNoSpaceIndent=0
" let g:rapidNoPath=0
" let g:rapidNoVerbose=1 " siehe oben g:knop...
" let g:rapidRhsQuickfix " siehe oben g:knop...
" let g:rapidLhsQuickfix " siehe oben g:knop...

" Note: krl options
" look also into ~/vimfiles/after/ftplugin/krl.vim
" let g:krlNoCommentIndent=0 " undokumentiert!
" let g:krlCommentIndent=0
" let g:krlFoldKeyMap=1 " deprecated
" let g:krlFoldingKeyMap=1
" let g:krlMoveAroundKeyMap=0
" let g:krlGoDefinitionKeyMap=1
" nnoremap gd gd
" nmap ggd <plug>KrlGoDef
" let g:krlListDefKeyMap=1
" nnoremap <leader>f gd
" let g:krlListUsageKeyMap=1
" let g:krlAutoFormKeyMap=1
let g:krlPathToBodyFiles='d:\daten\scripts\vim_resource\krl resource\'
" let g:krlAutoFormUpperCase=1
" let g:krlGroupName=0
" let g:krlNoHighLink=0
" let g:krlNoHighlight=1
" let g:krlShowError=1
" let g:krlFormatComments=0
" let g:krlAutoComment=0
" let g:krlCloseFolds=1
let g:krlFoldLevel=2
" let g:krlFoldMethodSyntax=1
" let g:krlNoIndent=0
" let g:krlNoSpaceIndent=0
" let g:krlNoKeyWord=0
" let g:krlNoPath=0
" let g:krlNoVerbose=1 " siehe oben g:knop...
" let g:krlRhsQuickfix " siehe oben g:knop...
" let g:krlLhsQuickfix " siehe oben g:knop...

" packadd <ordnername_wie_unterhalb_opt>

function! CleverTab()
  if strpart( getline('.'), 0, col('.')-1 ) =~ '\(^\s*\|\s\)$'
    return "\<Tab>"
  endif
  return "\<C-P>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

" let g:rapidGroupName=0
" let g:krlGroupName=0
colorscheme tortusless


if has("gui_running")
  " set guifont=Consolas:h14
  set guifont=terminus:h16
  " testzeile: 1lI7 2Z 5S 6b 08B0 pgq oO0Q ODODCO ‰ˆ¸ƒ÷‹ '` ,. :; +-*/= `''"'""`
  if 0
    let g:loeschmich="testzeile: 1lI7 2Z 5S 6b 08B0 pgq oO0Q ODODCO ‰ˆ¸ƒ÷‹ '` ,. :; +-*/= `''\"'\"\"`"
  endif
endif

" netrw
" let g:netrw_browse_split = 4 " open in previous window
" let g:netrw_winsize = 25 " sets the width to 25% of the page
let g:netrw_browse_split = 0 " reuse current window

" test!
" plugin vim-qf
let g:qf_window_bottom = 0
let g:qf_loclist_window_bottom = 0
let g:qf_mapping_ack_style = 1

command! BindBoth set scrollbind cursorbind | wincmd p | set scrollbind cursorbind | wincmd p
command! BindBothOff set noscrollbind nocursorbind | wincmd p | set noscrollbind nocursorbind | wincmd p
nnoremap <leader>bon :BindBoth<CR>
nnoremap <leader>bof :BindBothOff<CR>


" vim:sw=2 sts=2 et
