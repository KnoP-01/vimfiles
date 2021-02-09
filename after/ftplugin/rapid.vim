
" global substitute
nmap <leader>gs :set hidden<cr>*N<leader>u:cdo s///g<left><left>

" keyword lookup with K
"
" Das folgende ist die cmd.exe version
" if has("win32")
"   let g:rapidPathToSumatraPDF='c:\apps\SumatraPDF\SumatraPDF.exe'
"   let g:rapidPathToRefGuide='d:\daten\doku\abb\RefGuide_RW6.10\abb_reference_inst_func_dat.pdf'
"   nnoremap <buffer> <silent> K :let rapidCmd=
"         \"! start " .
"         \g:rapidPathToSumatraPDF .
"         \" -named-dest \"" .
"         \expand("<cword>") .
"         \" -\" " .
"         \g:rapidPathToRefGuide
"         \<bar>
"         \silent execute rapidCmd<cr>
" endif
"
" Das hier ist die git-for-win shell version
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
function AlignEio() abort
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
function UnAlignEio() abort
  g/\n[^#]/s/\([^#]\)$/\1\r/
  g/\\\s*\S/s/\\/\\\r/g
  %s/\s\s\+-/ -/g
  %s/^\s\+-/      -/
endfunction
command! EioUnAlign call UnAlignEio()

if exists('g:loaded_switch')

  if !exists('s:RapidUseFwdBwdDictForSwitch')
    function s:RapidUseFwdBwdDictForSwitch() abort
      let l:cword = expand('<cword>')
      return    l:cword =~ '\c\v^(inpos|stoptime\d_|fllwtime\d_)\d+$'
            \|| l:cword =~ '\c\v^(fine|z\d+|v\d+|vmax|vrot\d+|vlin\d+)$'
    endfunction

    function s:RapidSwitch() abort
      if s:RapidUseFwdBwdDictForSwitch()
        silent call switch#Switch({'definitions': b:rapidSwitchFwd})
        silent! call repeat#set(":RapidSwitch\<cr>")
      else
        silent call switch#Switch()
        silent! call repeat#set(":Switch\<cr>")
      endif
    endfunction

    function s:RapidSwitchReverse() abort
      if s:RapidUseFwdBwdDictForSwitch()
        silent call switch#Switch({'definitions': b:rapidSwitchBwd})
        silent! call repeat#set(":RapidSwitchReverse\<cr>")
      else
        silent call switch#Switch({'reverse': 1})
        silent! call repeat#set(":SwitchReverse\<cr>")
      endif
    endfunction
    command RapidSwitch call s:RapidSwitch()
    command RapidSwitchReverse call s:RapidSwitchReverse()
  endif

  nnoremap <buffer> <silent> <Plug>RapidSwitchFwd :RapidSwitch<cr>
  nnoremap <buffer> <silent> <Plug>RapidSwitchBwd :RapidSwitchReverse<cr>
  nmap <buffer> gs <Plug>RapidSwitchFwd
  nmap <buffer> ga <Plug>RapidSwitchBwd

  let b:rapidSwitchFwd =
        \ [
        \   {
        \     '\c\<inpos20\>'     : 'inpos50',
        \     '\c\<inpos50\>'     : 'inpos100',
        \     '\c\<inpos100\>'    : 'stoptime0_5',
        \     '\c\<stoptime0_5\>' : 'stoptime1_0',
        \     '\c\<stoptime1_0\>' : 'stoptime1_5',
        \     '\c\<stoptime1_5\>' : 'fllwtime0_5',
        \     '\c\<fllwtime0_5\>' : 'fllwtime1_0',
        \     '\c\<fllwtime1_0\>' : 'fllwtime1_5',
        \     '\c\<fllwtime1_5\>' : 'inpos20',
        \   },
        \   {
        \     '\c\<fine\>'  : 'z5',
        \     '\c\<z5\>'    : 'z10',
        \     '\c\<z10\>'   : 'z30',
        \     '\c\<z30\>'   : 'z50',
        \     '\c\<z50\>'   : 'z100',
        \     '\c\<z100\>'  : 'z200',
        \     '\c\<z200\>'  : 'fine',
        \   },
        \   {
        \     '\c\<z\d\+\>' : 'z100',
        \   },
        \   {
        \     '\c\<v5\>'    : 'v10',
        \     '\c\<v10\>'   : 'v20',
        \     '\c\<v20\>'   : 'v50',
        \     '\c\<v50\>'   : 'v100',
        \     '\c\<v100\>'  : 'v200',
        \     '\c\<v200\>'  : 'v500',
        \     '\c\<v500\>'  : 'v1000',
        \     '\c\<v1000\>' : 'v2000',
        \     '\c\<v2000\>' : 'v3000',
        \     '\c\<v3000\>' : 'v5000',
        \     '\c\<v5000\>' : 'v7000',
        \     '\c\<v7000\>' : 'vmax',
        \     '\c\<vmax\>'  : 'v5',
        \   },
        \   {
        \     '\c\<v\d\+\>' : 'v2000',
        \   },
        \   {
        \     '\c\<vrot1\>'   : 'vrot2',
        \     '\c\<vrot2\>'   : 'vrot5',
        \     '\c\<vrot5\>'   : 'vrot10',
        \     '\c\<vrot10\>'  : 'vrot20',
        \     '\c\<vrot20\>'  : 'vrot50',
        \     '\c\<vrot50\>'  : 'vrot100',
        \     '\c\<vrot100\>' : 'vrot1',
        \   },
        \   {
        \     '\c\<vlin10\>'   : 'vlin20',
        \     '\c\<vlin20\>'   : 'vlin50',
        \     '\c\<vlin50\>'   : 'vlin100',
        \     '\c\<vlin100\>'  : 'vlin200',
        \     '\c\<vlin200\>'  : 'vlin500',
        \     '\c\<vlin500\>'  : 'vlin1000',
        \     '\c\<vlin1000\>' : 'vlin10',
        \   },
        \ ]

  let b:rapidSwitchBwd =
        \ [
        \   {
        \     '\c\<fllwtime1_5\>' : 'fllwtime1_0',
        \     '\c\<fllwtime1_0\>' : 'fllwtime0_5',
        \     '\c\<fllwtime0_5\>' : 'stoptime1_5',
        \     '\c\<stoptime1_5\>' : 'stoptime1_0',
        \     '\c\<stoptime1_0\>' : 'stoptime0_5',
        \     '\c\<stoptime0_5\>' : 'inpos100',
        \     '\c\<inpos100\>'    : 'inpos50',
        \     '\c\<inpos50\>'     : 'inpos20',
        \     '\c\<inpos20\>'     : 'fllwtime1_5',
        \   },
        \   {
        \     '\c\<z200\>'  : 'z100',
        \     '\c\<z100\>'  : 'z50',
        \     '\c\<z50\>'   : 'z30',
        \     '\c\<z30\>'   : 'z10',
        \     '\c\<z10\>'   : 'z5',
        \     '\c\<z5\>'    : 'fine',
        \     '\c\<fine\>'  : 'z200',
        \   },
        \   {
        \     '\c\<z\d\+\>' : 'z100',
        \   },
        \   {
        \     '\c\<vmax\>'  : 'v7000',
        \     '\c\<v7000\>' : 'v5000',
        \     '\c\<v5000\>' : 'v3000',
        \     '\c\<v3000\>' : 'v2000',
        \     '\c\<v2000\>' : 'v1000',
        \     '\c\<v1000\>' : 'v500',
        \     '\c\<v500\>'  : 'v200',
        \     '\c\<v200\>'  : 'v100',
        \     '\c\<v100\>'  : 'v50',
        \     '\c\<v50\>'   : 'v20',
        \     '\c\<v20\>'   : 'v10',
        \     '\c\<v10\>'   : 'v5',
        \     '\c\<v5\>'    : 'vmax',
        \   },
        \   {
        \     '\c\<v\d\+\>' : 'v2000',
        \   },
        \   {
        \     '\c\<vrot100\>' : 'vrot50',
        \     '\c\<vrot50\>'  : 'vrot20',
        \     '\c\<vrot20\>'  : 'vrot10',
        \     '\c\<vrot10\>'  : 'vrot5',
        \     '\c\<vrot5\>'   : 'vrot2',
        \     '\c\<vrot2\>'   : 'vrot1',
        \     '\c\<vrot1\>'   : 'vrot100',
        \   },
        \   {
        \     '\c\<vlin1000\>' : 'vlin500',
        \     '\c\<vlin500\>'  : 'vlin200',
        \     '\c\<vlin200\>'  : 'vlin100',
        \     '\c\<vlin100\>'  : 'vlin50',
        \     '\c\<vlin50\>'   : 'vlin20',
        \     '\c\<vlin20\>'   : 'vlin10',
        \     '\c\<vlin10\>'   : 'vlin1000',
        \   },
        \ ]

  let b:switch_custom_definitions =
        \ [
        \   {
        \     '\C\<TRUE\>'  : 'FALSE',
        \     '\C\<FALSE\>' : 'TRUE',
        \   },
        \   {
        \     '\C\<True\>'  : 'False',
        \     '\C\<False\>' : 'True',
        \   },
        \   {
        \     '\c\<true\>'  : 'false',
        \     '\c\<false\>' : 'true',
        \   },
        \   {
        \     '\C\<HIGH\>' : 'LOW',
        \     '\C\<LOW\>'  : 'HIGH',
        \   },
        \   {
        \     '\C\<High\>' : 'Low',
        \     '\C\<Low\>'  : 'High',
        \   },
        \   {
        \     '\c\<high\>' : 'low',
        \     '\c\<low\>'  : 'high',
        \   },
        \   {
        \     '\C\<AND\>' : 'OR',
        \     '\C\<OR\>'  : 'XOR',
        \     '\C\<XOR\>' : 'AND',
        \   },
        \   {
        \     '\C\<And\>' : 'Or',
        \     '\C\<Or\>'  : 'XOr',
        \     '\C\<XOr\>' : 'And',
        \   },
        \   {
        \     '\c\<and\>' : 'or',
        \     '\c\<or\>'  : 'xor',
        \     '\c\<xor\>' : 'and',
        \   },
        \   {
        \     '\c(\(not\)\@!'       : '(not ',
        \     '\c(not '             : '(',
        \     '\c\(not\)\@3<! (\@=' : ' not ',
        \     '\c not (\@='         : ' ',
        \   },
        \   {
        \     '\C\<DIV\>' : 'MOD',
        \     '\C\<MOD\>' : 'DIV',
        \   },
        \   {
        \     '\C\<Div\>' : 'Mod',
        \     '\C\<Mod\>' : 'Div',
        \   },
        \   {
        \     '\c\<div\>' : 'mod',
        \     '\c\<mod\>' : 'div',
        \   },
        \   {
        \     '='  : '>=',
        \     '>=' : '<=',
        \     '<=' : '<>',
        \     '<>' : '=',
        \   },
        \   {
        \     '\c\v<BitAnd(Dnum)?>'   : 'BitOr\L\u\1',
        \     '\c\v<BitOr(Dnum)?>'    : 'BitXOr\L\u\1',
        \     '\c\v<BitXOr(Dnum)?>'   : 'BitAnd\L\u\1',
        \   },
        \   {
        \     '\c\v<BitRSh(Dnum)?>' : 'BitLSh\L\u\1',
        \     '\c\v<BitLSh(Dnum)?>' : 'BitRSh\L\u\1',
        \   },
        \   {
        \     '\c\v<Trunc(Dnum)?>' : 'Round\L\u\1',
        \     '\c\v<Round(Dnum)?>' : 'Trunc\L\u\1',
        \   },
        \   {
        \     '\c\v<(A)?Sin(Dnum)?>' : '\1Cos\L\u\2',
        \     '\c\v<(A)?Cos(Dnum)?>' : '\1Tan\L\u\2',
        \     '\c\v<ATan(Dnum)?>'    : 'ATan2\L\u\1',
        \     '\c\v<ATan2(Dnum)?>'   : 'ASin\L\u\1',
        \     '\c\v<Tan(Dnum)?>'     : 'Sin\L\u\1',
        \   },
        \   {
        \     '\C\v^(\s*)<ELSEIF>\s*$'            :  '\1ELSE',
        \     '\C\v^(\s*)<ELSE>\s*$'              :  '\1ELSEIF ',
        \     '\C\v^(\s*)<ELSEIF>([^!]+)'         :  '\1ELSE !\2%',
        \     '\C\v^(\s*)<ELSE>\s?(\s*)!?(.*)\%'  :  '\1ELSEIF\2\3',
        \   },
        \   {
        \     '\C\v^(\s*)<ElseIf>\s*$'            :  '\1Else',
        \     '\C\v^(\s*)<Else>\s*$'              :  '\1ElseIf ',
        \     '\C\v^(\s*)<ElseIf>([^!]+)'         :  '\1Else !\2%',
        \     '\C\v^(\s*)<Else>\s?(\s*)!?(.*)\%'  :  '\1ElseIf\2\3',
        \   },
        \   {
        \     '\c\v^(\s*)<elseif>\s*$'            :  '\1else',
        \     '\c\v^(\s*)<else>\s*$'              :  '\1elseif ',
        \     '\c\v^(\s*)<elseif>([^!]+)'         :  '\1else !\2%',
        \     '\c\v^(\s*)<else>\s?(\s*)!?(.*)\%'  :  '\1elseif\2\3',
        \   },
        \   {
        \     '\C\v^(\s*)<CASE>([^!]*):'            : '\1DEFAULT: !\2%',
        \     '\C\v^(\s*)<DEFAULT>\s*:(\s*!.*\%)?'  : '\1ENDTEST\2',
        \     '\C\v^(\s*)<ENDTEST>\s?(\s*)!(.*)\%'  : '\1CASE\2\3:',
        \     '\C\v^(\s*)<ENDTEST>(\s*!?[^%]*)$'  : '\1DEFAULT:\2',
        \   },
        \   {
        \     '\C\v^(\s*)<Case>([^!]*):'            : '\1Default: !\2%',
        \     '\C\v^(\s*)<Default>\s*:(\s*!.*\%)?'  : '\1EndTest\2',
        \     '\C\v^(\s*)<EndTest>\s?(\s*)!(.*)\%'  : '\1Case\2\3:',
        \     '\C\v^(\s*)<EndTest>(\s*!?[^%]*)$'  : '\1Default:\2',
        \   },
        \   {
        \     '\c\v^(\s*)<case>([^!]*):'            : '\1default: !\2%',
        \     '\c\v^(\s*)<default>\s*:(\s*!.*\%)?'  : '\1endtest\2',
        \     '\c\v^(\s*)<endtest>\s?(\s*)!(.*)\%'  : '\1case\2\3:',
        \     '\c\v^(\s*)<endtest>(\s*!?[^%]*)$'  : '\1default:\2',
        \   },
        \   {
        \     '\c\<local\>' : 'TASK',
        \     '\c\<task\>'  : 'LOCAL',
        \   },
        \   {
        \     '\c\<var\>'   : 'PERS',
        \     '\c\<pers\>'  : 'CONST',
        \     '\c\<const\>' : 'VAR',
        \   },
        \   {
        \     '\c\v^(\s*)(Move)J>'                               : '\1\L\u\2\EAbsJ',
        \     '\c\v^(\s*)(Move)AbsJ>'                            : '\1\L\u\2\EL',
        \     '\c\v^(\s*)(Move|Trigg)J(IOs|AO|DO|GO|Sync)?>'  : '\1\L\u\2\EL\3',
        \     '\c\v^(\s*)(Move|Trigg)L(IOs|AO|DO|GO|Sync)?>'  : '\1\L\u\2\EC\3',
        \     '\c\v^(\s*)(Move|Trigg)C(IOs|AO|DO|GO|Sync)?>'  : '\1\L\u\2\EJ\3',
        \   },
        \   {
        \     '\c\v^(\s*)(Arc)(Adapt|Calc)?([CL])([12])?Start>' : '\1\L\u\2\E\3\L\u\4\5',
        \     '\c\v^(\s*)(Arc)(Adapt|Calc)?([CL])([12])?>'      : '\1\L\u\2\E\3\L\u\4\5\EEnd',
        \     '\c\v^(\s*)(Arc)(Adapt|Calc)?([CL])([12])?End>'   : '\1\L\u\2\E\3\L\u\4\5\EStart',
        \   },
        \   {
        \     '\c\v^(\s*)(Nut|Spot|Calib)(M)?L' : '\1\L\u\2\U\3J',
        \     '\c\v^(\s*)(Nut|Spot|Calib)(M)?J' : '\1\L\u\2\U\3L',
        \   },
        \   {
        \     '\c\v^(\s*)DaProcML' : '\1DaProcMJ',
        \     '\c\v^(\s*)DaProcMJ' : '\1DaProcML',
        \   },
        \   {
        \     '\c\v^(\s*)(Cap|Disp|Paint|Search)L' : '\1\L\u\2\EC',
        \     '\c\v^(\s*)(Cap|Disp|Paint|Search)C' : '\1\L\u\2\EL',
        \   },
        \   {
        \     '\c\v^(\s*)EGMMoveL' : '\1EGMMoveC',
        \     '\c\v^(\s*)EGMMoveC' : '\1EGMMoveL',
        \   },
        \   {
        \     '\c\v^(\s*)IndAMove>'  : '\1IndCMove',
        \     '\c\v^(\s*)IndCMove>'  : '\1IndDMove',
        \     '\c\v^(\s*)IndDMove>'  : '\1IndRMove',
        \     '\c\v^(\s*)IndRMove>'  : '\1IndAMove',
        \   },
        \   {
        \     '\c\v^(\s*)(S)(Move|Trigg)J(DO|GO|Sync)?' : '\1\u\2\L\u\3\EL\4',
        \     '\c\v^(\s*)(S)(Move|Trigg)L(DO|GO|Sync)?' : '\1\u\2\L\u\3\EJ\4',
        \   },
        \   {
        \     '\c\v^(\s*)StartMove>'       : '\1StartMoveRetry',
        \     '\c\v^(\s*)StartMoveRetry>'  : '\1StopMove',
        \     '\c\v^(\s*)StopMove>'        : '\1StopMoveReset',
        \     '\c\v^(\s*)StopMoveReset>'   : '\1StartMove',
        \   },
        \   {
        \     '\c\v^(\s*)Set>'   : '\1Reset',
        \     '\c\v^(\s*)Reset>' : '\1Set',
        \   },
        \   {
        \     '\c\v^(\s*)Open>'  : '\1Write',
        \     '\c\v^(\s*)Write>' : '\1Close',
        \     '\c\v^(\s*)Close>' : '\1Open',
        \   },
        \   {
        \     '\c\v^(\s*)OpenDir>'  : '\1CloseDir',
        \     '\c\v^(\s*)CloseDir>' : '\1OpenDir',
        \   },
        \   {
        \     '\c\v^(\s*)DeactUnit>'  : '\1ActUnit',
        \     '\c\v^(\s*)ActUnit>'    : '\1DeactUnit',
        \   },
        \   {
        \     '\c\v^(\s*)DropWObj>' : '\1WaitWObj',
        \     '\c\v^(\s*)WaitWObj>' : '\1DropWObj',
        \   },
        \   {
        \     '\c\v^(\s*)ConfJ>' : '\1ConfL',
        \     '\c\v^(\s*)ConfL>' : '\1ConfJ',
        \   },
        \   {
        \     '\c\v<Off>' : 'On',
        \     '\c\v<On>'  : 'Off',
        \   },
        \   {
        \     '\c\v^(\s*)EOffsOff>' : '\1EOffsOn',
        \     '\c\v^(\s*)EOffsOn>'  : '\1EOffsSet',
        \     '\c\v^(\s*)EOffsSet>' : '\1EOffsOff',
        \   },
        \   {
        \     '\c\v^(\s*)Incr>'  : '\1Decr',
        \     '\c\v^(\s*)Decr>'  : '\1Clear',
        \     '\c\v^(\s*)Clear>' : '\1Incr',
        \   },
        \   {
        \     '\c\v^(\s*)ClkReset>' : '\1ClkStart',
        \     '\c\v^(\s*)ClkStart>' : '\1ClkStop',
        \     '\c\v^(\s*)ClkStop>'  : '\1ClkReset',
        \   },
        \   {
        \     '\c\v^(\s*)IOEnable>'  : '\1IODisable',
        \     '\c\v^(\s*)IODisable>' : '\1IOEnable',
        \   },
        \   {
        \     '\c\v^(\s*)IWatch>'   : '\1ISleep',
        \     '\c\v^(\s*)ISleep>'   : '\1IDelete',
        \     '\c\v^(\s*)IDelete>'  : '\1IEnable',
        \     '\c\v^(\s*)IEnable>'  : '\1IDisable',
        \     '\c\v^(\s*)IDisable>' : '\1IWatch',
        \   },
        \   {
        \     '\c\v^(\s*)ISignalAI>' : '\1ISignalAO',
        \     '\c\v^(\s*)ISignalAO>' : '\1ISignalAI',
        \   },
        \   {
        \     '\c\v^(\s*)ISignalDI>' : '\1ISignalDO',
        \     '\c\v^(\s*)ISignalDO>' : '\1ISignalDI',
        \   },
        \   {
        \     '\c\v^(\s*)ISignalGI>' : '\1ISignalGO',
        \     '\c\v^(\s*)ISignalGO>' : '\1ISignalGI',
        \   },
        \   {
        \     '\c\v^(\s*)Load>'   : '\1Save',
        \     '\c\v^(\s*)Save>'   : '\1UnLoad',
        \     '\c\v^(\s*)UnLoad>' : '\1Load',
        \   },
        \   {
        \     '\c\v^(\s*)MakeDir>'   : '\1RemoveDir',
        \     '\c\v^(\s*)RemoveDir>' : '\1MakeDir',
        \   },
        \   {
        \     '\c\v^(\s*)PathRecStart>' : '\1PathRecStop',
        \     '\c\v^(\s*)PathRecStop>'  : '\1PathRecStart',
        \   },
        \   {
        \     '\c\v^(\s*)PathRecMoveBwd>' : '\1PathRecMoveFwd',
        \     '\c\v^(\s*)PathRecMoveFwd>' : '\1PathRecMoveBwd',
        \   },
        \   {
        \     '\c\v^(\s*)RenameFile>' : '\1RemoveFile',
        \     '\c\v^(\s*)RemoveFile>' : '\1RenameFile',
        \   },
        \   {
        \     '\c\v^(\s*)Retry>'   : '\1TryNext',
        \     '\c\v^(\s*)TryNext>' : '\1Retry',
        \   },
        \   {
        \     '\c\v^(\s*)SetDO>' : '\1SetGO',
        \     '\c\v^(\s*)SetGO>' : '\1SetAO',
        \     '\c\v^(\s*)SetAO>' : '\1SetDO',
        \   },
        \   {
        \     '\c\v^(\s*)SocketCreate>'      : '\1SocketListen',
        \     '\c\v^(\s*)SocketListen>'      : '\1SocketBind',
        \     '\c\v^(\s*)SocketBind>'        : '\1SocketConnect',
        \     '\c\v^(\s*)SocketConnect>'     : '\1SocketAccept',
        \     '\c\v^(\s*)SocketAccept>'      : '\1SocketReceive',
        \     '\c\v^(\s*)SocketReceive>'     : '\1SocketReceiveFrom',
        \     '\c\v^(\s*)SocketReceiveFrom>' : '\1SocketSend',
        \     '\c\v^(\s*)SocketSend>'        : '\1SocketSendTo',
        \     '\c\v^(\s*)SocketSendTo>'      : '\1SocketClose',
        \     '\c\v^(\s*)SocketClose>'       : '\1SocketCreate',
        \   },
        \   {
        \     '\c\v^(\s*)SoftAct>'   : '\1SoftDeact',
        \     '\c\v^(\s*)SoftDeact>' : '\1SoftAct',
        \   },
        \   {
        \     '\c\v^(\s*)SyncMoveOn>'  : '\1SyncMoveOff',
        \     '\c\v^(\s*)SyncMoveOff>' : '\1SyncMoveOn',
        \   },
        \   {
        \     '\c\v^(\s*)SyncMoveSuspend>' : '\1SyncMoveResume',
        \     '\c\v^(\s*)SyncMoveResume>'  : '\1SyncMoveSuspend',
        \   },
        \   {
        \     '\c\v^(\s*)WaitAI>' : '\1WaitAO',
        \     '\c\v^(\s*)WaitAO>' : '\1WaitDI',
        \     '\c\v^(\s*)WaitDI>' : '\1WaitDO',
        \     '\c\v^(\s*)WaitDO>' : '\1WaitGI',
        \     '\c\v^(\s*)WaitGI>' : '\1WaitGO',
        \     '\c\v^(\s*)WaitGO>' : '\1WaitAI',
        \   },
        \   {
        \     '\c\v^(\s*)WZBoxDef>'       : '\1WZCylDef',
        \     '\c\v^(\s*)WZCylDef>'       : '\1WZSphDef',
        \     '\c\v^(\s*)WZSphDef>'       : '\1WZHomeJointDef',
        \     '\c\v^(\s*)WZHomeJointDef>' : '\1WZLimJointDef',
        \     '\c\v^(\s*)WZLimJointDef>'  : '\1WZBoxDef',
        \   },
        \   {
        \     '\c\<STR_DIGIT\>'  : 'STR_LOWER',
        \     '\c\<STR_LOWER\>'  : 'STR_UPPER',
        \     '\c\<STR_UPPER\>'  : 'STR_WHITE',
        \     '\c\<STR_WHITE\>'  : 'STR_DIGIT',
        \   },
        \   {
        \     '\c\<USINT\>' : 'UINT',
        \     '\c\<UINT\>'  : 'UDINT',
        \     '\c\<UDINT\>' : 'ULINT',
        \     '\c\<ULINT\>' : 'SINT',
        \     '\c\<SINT\>'  : 'INT',
        \     '\c\<INT\>'   : 'DINT',
        \     '\c\<DINT\>'  : 'LINT',
        \     '\c\<LINT\>'  : 'USINT',
        \   },
        \   {
        \     '\c\<OpAdd\>'  : 'OpSub',
        \     '\c\<OpSub\>'  : 'OpMult',
        \     '\c\<OpMult\>' : 'OpDiv',
        \     '\c\<OpDiv\>'  : 'OpMod',
        \     '\c\<OpMod\>'  : 'OpAdd',
        \   },
        \   {
        \     '\c\<TRIGG_MODE1\>' : 'TRIGG_MODE2',
        \     '\c\<TRIGG_MODE2\>' : 'TRIGG_MODE3',
        \     '\c\<TRIGG_MODE3\>' : 'TRIGG_MODE1',
        \   },
        \   {
        \     '\c\<OP_NO_ROBOT\>'   : 'OP_SERVICE',
        \     '\c\<OP_SERVICE\>'    : 'OP_PRODUCTION',
        \     '\c\<OP_PRODUCTION\>' : 'OP_NO_ROBOT',
        \   },
        \   {
        \     '\c\<CT_CONTINUOUS\>'       : 'CT_COUNT_CYCLES',
        \     '\c\<CT_COUNT_CYCLES\>'     : 'CT_COUNT_CYC_ACTION',
        \     '\c\<CT_COUNT_CYC_ACTION\>' : 'CT_PERIODICAL',
        \     '\c\<CT_PERIODICAL\>'       : 'CT_CONTINUOUS',
        \   },
        \   {
        \     '\c\<TP_LATEST\>'       : 'TP_PROGRAM',
        \     '\c\<TP_PROGRAM\>'      : 'TP_SCREENVIEWER',
        \     '\c\<TP_SCREENVIEWER\>' : 'TP_LATEST',
        \   },
        \   {
        \     '\c\<STATE_ERROR\>'     : 'STATE_UNDEFINED',
        \     '\c\<STATE_UNDEFINED\>' : 'STATE_CONNECTED',
        \     '\c\<STATE_CONNECTED\>' : 'STATE_OPERATING',
        \     '\c\<STATE_OPERATING\>' : 'STATE_CLOSED',
        \     '\c\<STATE_CLOSED\>'    : 'STATE_ERROR',
        \   },
        \   {
        \     '\c\<SIGORIG_NONE\>'  : 'SIGORIG_CFG',
        \     '\c\<SIGORIG_CFG\>'   : 'SIGORIG_ALIAS',
        \     '\c\<SIGORIG_ALIAS\>' : 'SIGORIG_NONE',
        \   },
        \   {
        \     '\c\<AIO_ABOVE_HIGH\>' : 'AIO_BELOW_HIGH',
        \     '\c\<AIO_BELOW_HIGH\>' : 'AIO_ABOVE_LOW',
        \     '\c\<AIO_ABOVE_LOW\>'  : 'AIO_BELOW_LOW',
        \     '\c\<AIO_BELOW_LOW\>'  : 'AIO_BETWEEN',
        \     '\c\<AIO_BETWEEN\>'    : 'AIO_OUTSIDE',
        \     '\c\<AIO_OUTSIDE\>'    : 'AIO_ALWAYS',
        \     '\c\<AIO_ALWAYS\>'     : 'AIO_ABOVE_HIGH',
        \   },
        \   {
        \     '\c\<SOCKET_CREATED\>'   : 'SOCKET_CONNECTED',
        \     '\c\<SOCKET_CONNECTED\>' : 'SOCKET_BOUND',
        \     '\c\<SOCKET_BOUND\>'     : 'SOCKET_LISTENING',
        \     '\c\<SOCKET_LISTENING\>' : 'SOCKET_CLOSED',
        \     '\c\<SOCKET_CLOSED\>'    : 'SOCKET_CREATED',
        \   },
        \   {
        \     '\c\<OP_UNDEF\>'    : 'OP_AUTO',
        \     '\c\<OP_AUTO\>'     : 'OP_MAN_PROG',
        \     '\c\<OP_MAN_PROG\>' : 'OP_MAN_TEST',
        \     '\c\<OP_MAN_TEST\>' : 'OP_UNDEF',
        \   },
        \   {
        \     '\c\<RUN_UNDEF\>'      : 'RUN_SIM',
        \     '\c\<RUN_SIM\>'        : 'RUN_CONT_CYCLE',
        \     '\c\<RUN_CONT_CYCLE\>' : 'RUN_STEP_MOVE',
        \     '\c\<RUN_STEP_MOVE\>'  : 'RUN_INSTR_FWD',
        \     '\c\<RUN_INSTR_FWD\>'  : 'RUN_INSTR_BWD',
        \     '\c\<RUN_INSTR_BWD\>'  : 'RUN_UNDEF',
        \   },
        \   {
        \     '\c\<EVENT_NONE\>'    : 'EVENT_POWERON',
        \     '\c\<EVENT_POWERON\>' : 'EVENT_START',
        \     '\c\<EVENT_START\>'   : 'EVENT_STOP',
        \     '\c\<EVENT_STOP\>'    : 'EVENT_QSTOP',
        \     '\c\<EVENT_QSTOP\>'   : 'EVENT_RESTART',
        \     '\c\<EVENT_RESTART\>' : 'EVENT_RESET',
        \     '\c\<EVENT_RESET\>'   : 'EVENT_STEP',
        \     '\c\<EVENT_STEP\>'    : 'EVENT_NONE',
        \   },
        \   {
        \     '\c\<HANDLER_NONE\>' : 'HANDLER_BWD',
        \     '\c\<HANDLER_BWD\>'  : 'HANDLER_ERR',
        \     '\c\<HANDLER_ERR\>'  : 'HANDLER_UNDO',
        \     '\c\<HANDLER_UNDO\>' : 'HANDLER_NONE',
        \   },
        \   {
        \     '\c\<LEVEL_NORMAL\>'  : 'LEVEL_TRAP',
        \     '\c\<LEVEL_TRAP\>'    : 'LEVEL_SERVICE',
        \     '\c\<LEVEL_SERVICE\>' : 'LEVEL_NORMAL',
        \   },
        \   {
        \     '\c\<SIGORIG_NONE\>'  : 'SIGORIG_CFG',
        \     '\c\<SIGORIG_CFG\>'   : 'SIGORIG_ALIAS',
        \     '\c\<SIGORIG_ALIAS\>' : 'SIGORIG_NONE',
        \   },
        \   {
        \     '\c\<LT\>'    : 'LTEQ',
        \     '\c\<LTEQ\>'  : 'EQ',
        \     '\c\<EQ\>'    : 'NOTEQ',
        \     '\c\<NOTEQ\>' : 'GTEQ',
        \     '\c\<GTEQ\>'  : 'GT',
        \     '\c\<GT\>'    : 'LT',
        \   },
        \ ]
endif

" vim:sw=2 sts=2 et fdm=marker fmr={{{,}}}
