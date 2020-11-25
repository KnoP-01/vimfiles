
* `<leader>l` := open this file  
  
------------------------------------------------------------------------------
# To Practice On
* `CTRL-O`, `CTRL-I` := older/newer far jump position
* `f`,`t`,`F`,`T`,`;` and , := inline movements  
* remember the indent text object
* `i_CTRL-w` := delete last word, I always foget about that
* `:B <cmd>` := execute command on a visual block
  
------------------------------------------------------------------------------
# New Discoveries
## Uncategorized
* `v_o` = go to the opposite side of the current visual selection
* `:?patter?c.<cr>` = search backward for pattern and copy found line to the
    current one
* `q:` = edit commandline like any buffer `c_CRTL-F` also works 
* `CTRL-C`    := go back to normal command line after q: or c_CTRL-F
* `i_CTRL-O`    := exec a single normal mode command in insert mode
* `:Cfilter`    := filter quick fix list  
  
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
