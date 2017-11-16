" Description: VimBuddy statusline character
" Author:      Flemming Madsen <vim@themadsens.dk>
" Modified:    August 2007
" Version:     0.9.2 mymod
"
" Usage:       Insert %{VimBuddy()} into your 'statusline'
"
function! VimBuddy()
    " Take a copy for others to see the messages
    if ! exists("s:vimbuddy_msg")
        let s:vimbuddy_msg = v:statusmsg
    endif
    if ! exists("s:vimbuddy_warn")
        let s:vimbuddy_warn = v:warningmsg
    endif
    if ! exists("s:vimbuddy_err")
        let s:vimbuddy_err = v:errmsg
    endif
    if ! exists("s:vimbuddy_onemore")
        let s:vimbuddy_onemore = ""
    endif

    if g:actual_curbuf != bufnr("%")
        " Not my buffer, sleeping
        return '|-o'
    elseif s:vimbuddy_err != v:errmsg
        let v:errmsg = v:errmsg . " "
        let s:vimbuddy_err = v:errmsg
        return ':-('
    elseif s:vimbuddy_warn != v:warningmsg
        let v:warningmsg = v:warningmsg . " "
        let s:vimbuddy_warn = v:warningmsg
        return '(-:'
    elseif s:vimbuddy_msg != v:statusmsg
        let v:statusmsg = v:statusmsg . " "
        let s:vimbuddy_msg = v:statusmsg
        let test = matchstr(v:statusmsg, 'lines *$')
        let num = substitute(v:statusmsg, '^\([0-9]*\).*', '\1', '') + 0
        " How impressed should we be
        if test != "" && num > 20
            let str = ":-O"
        elseif test != "" && num
            let str = ":-o"
        else
            let str = ":-/"
        endif
        let s:vimbuddy_onemore = str
        return str
    elseif s:vimbuddy_onemore != ""
        let str = s:vimbuddy_onemore
        let s:vimbuddy_onemore = ""
        return str
    endif

    if ! exists("b:lastline")
        let b:lastline = line(".") % 4
    endif
    if ! exists("b:lastcol")
        let b:lastcol = col(".") % 4
    endif
    if ! exists("b:lastnose")
        let b:lastnose = '-'
    endif
    let lnum = line(".") % 4
    let num = col(".") % 4
    if (num != b:lastcol || lnum != b:lastline)
        " Let VimBuddy rotate his nose
        if (lnum == b:lastline && (num==0 && b:lastcol==1 || num==1 && b:lastcol==2 || num==2 && b:lastcol==3 || num==3 && b:lastcol==0)) || (lnum==0 && b:lastline==1 || lnum==1 && b:lastline==2 || lnum==2 && b:lastline==3 || lnum==3 && b:lastline==0)
            if b:lastnose == '-' 
                let b:lastnose = '/'
            elseif b:lastnose == '/'
                let b:lastnose = '|'
            elseif b:lastnose == '|'
                let b:lastnose = '\'
            elseif b:lastnose == '\'
                let b:lastnose = '-'
            endif
        elseif (lnum == b:lastline && (num==0 && b:lastcol==3 || num==3 && b:lastcol==2 || num==2 && b:lastcol==1 || num==1 && b:lastcol==0)) || (lnum==0 && b:lastline==3 || lnum==3 && b:lastline==2 || lnum==2 && b:lastline==1 || lnum==1 && b:lastline==0)
            if b:lastnose == '-' 
                let b:lastnose = '\'
            elseif b:lastnose == '\'
                let b:lastnose = '|'
            elseif b:lastnose == '|'
                let b:lastnose = '/'
            elseif b:lastnose == '/'
                let b:lastnose = '-'
            endif
        endif
        let b:lastline = line(".") % 4
        let b:lastcol = col(".") % 4
    endif
    return ":" . b:lastnose . ")"

    " Happiness is my favourite mood
    return ':-)'
endfunction

" vim:sw=4 sts=4 et
