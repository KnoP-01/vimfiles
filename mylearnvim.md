* `%normal` := issue a normal mode command on all lines in a buffer.
* `[I` := Display all lines that contain the keyword under the cursor.
* `<leader>l` := open this file  
  
------------------------------------------------------------------------------
# RegEx
* `/\%[` starti\%[nsert] 
  
------------------------------------------------------------------------------
# To Practice On
* `CTRL-O`, `CTRL-I` := older/newer far jump position
* `f`,`t`,`F`,`T`,`;` and , := inline movements  
* remember the indent text object
* `i_CTRL-w` := delete last word, I always foget about that
* `:B <cmd>` := execute command on a visual block
* `<leader>gs` := global substitute in Rapid/KRL-files
  
------------------------------------------------------------------------------
# New Discoveries
## Uncategorized
* `gn` = movement to next match (like n) but visually selects match
* `cgn` = change next match: /something<cr>, cwbla<esc>, cgn (change next
    something)
* `v_o` = go to the opposite side of the current visual selection
* `v_O` = go to the opposite side of the current visual selection (different
    from v_o only in visual block mode)
* `:?patter?c.<cr>` = search backward for pattern and copy found line to the
    current one
* `q:` = edit commandline like any buffer `c_CRTL-F` also works 
* `CTRL-C`    := go back to normal command line after q: or c_CTRL-F
* `i_CTRL-O`    := exec a single normal mode command in insert mode
* `:Cfilter`    := filter quick fix list  
* `i_CTRL-A`    := redo last insert (insert previously inserted text)
  
## completion
### command line mode completion
* `c_CTRL-F`    := edit commandline like any buffer
* `c_CTRL-D`    := clipboard (selection)
* `c_CTRL-R *`  := clipboard (selection)
* `c_CTRL-R +`  := clipboard
* `c_CTRL-R %`  := current file name
* `c_CTRL-R -`  := last small delete
* `c_CTRL-R 1`  := last big delete
* `c_CTRL-R 0`  := last big yank
* `c_CTRL-R c_CTRL-W`   := word under the cursor
* `c_CTRL-R c_CTRL-A`   := WORD under the cursor
* `c_CTRL-R c_CTRL-L`   := line under the cursor
### insert mode completion
* `CTRL-R *` := clipboard (selection)
* `CTRL-R +` := clipboard
* `CTRL-R %` := current file name
* `CTRL-R .` := last inserted text
* `CTRL-R -` := last small delete
* `CTRL-R 1` := last big delete
* `CTRL-R 0` := last yank  
  
## character case
### normal mode
* `gu{motion}`, `gU{motion}` and `g~{motion}` := u=lower, U=upper and ~=swap
### visual mode
* `v<motion>u`, `v<motion>U`, `v<motion>~` := u=lower, U=upper and ~=swap  
  
------------------------------------------------------------------------------
# My Own Stuff
* `v_;` := auto create vimgrep line in visual mode
* `<leader><leader>` := CTRL-^
* `Y` := mapped to y$ to be consistent with D and C  
  
## Window stuff
* `<Alt-(hjkl)>`            := move cursor between windows
* `<Alt-(arrow keys)>`      := move window
* `<Ctrl-Alt-(arrow keys)>` := change size of window  
  
## Rapid/Krl
* `<leader>gs` := global substitute  
  
------------------------------------------------------------------------------
# In Use Frequently
* `''` (actually mapped to **``**) := last far jump position  
  

<!-- 
      vim:sw=2 sts=2 et textwidth=80 
                                      -->
