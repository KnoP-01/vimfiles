
" global substitute
nmap <leader>gs :set hidden<cr>*N<leader>u:cdo s///g<left><left>

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
      \     '\c\<fine\>'  : 'z10',
      \     '\c\<z10\>'   : 'z50',
      \     '\c\<z50\>'   : 'z100',
      \     '\c\<z100\>'  : 'z200',
      \     '\c\<z200\>'  : 'fine',
      \   },
      \   {
      \     '\c\<z\d\+\>' : 'z100',
      \   },
      \   {
      \     '\c\<v20\>'   : 'v50',
      \     '\c\<v50\>'   : 'v100',
      \     '\c\<v100\>'  : 'v200',
      \     '\c\<v200\>'  : 'v500',
      \     '\c\<v500\>'  : 'v1500',
      \     '\c\<v1500\>' : 'v2500',
      \     '\c\<v2500\>' : 'v5000',
      \     '\c\<v5000\>' : 'v7000',
      \     '\c\<v7000\>' : 'vmax',
      \     '\c\<vmax\>'  : 'v20',
      \   },
      \   {
      \     '\c\<v\d\+\>' : 'v1500',
      \   },
      \   {
      \     '\c\<vrot1\>'   : 'vrot2',
      \     '\c\<vrot2\>'   : 'vrot5',
      \     '\c\<vrot5\>'   : 'vrot10',
      \     '\c\<vrot10\>'  : 'vrot20',
      \     '\c\<vrot20\>'  : 'vrot50',
      \     '\c\<vrot50\>'  : 'vrot1',
      \   },
      \   {
      \     '\c\<vlin10\>'  : 'vlin20',
      \     '\c\<vlin20\>'  : 'vlin50',
      \     '\c\<vlin50\>'  : 'vlin100',
      \     '\c\<vlin100\>' : 'vlin200',
      \     '\c\<vlin200\>' : 'vlin500',
      \     '\c\<vlin500\>' : 'vlin10',
      \   },
      \ ]
let b:rapidSwitchBwd =
      \ [
      \   {
      \     '\c\<fllwtime1_5\>' : 'fllwtime1_0' , 
      \     '\c\<fllwtime1_0\>' : 'fllwtime0_5' , 
      \     '\c\<fllwtime0_5\>' : 'stoptime1_5' , 
      \     '\c\<stoptime1_5\>' : 'stoptime1_0' , 
      \     '\c\<stoptime1_0\>' : 'stoptime0_5' , 
      \     '\c\<stoptime0_5\>' : 'inpos100'    , 
      \     '\c\<inpos100\>'    : 'inpos50'     , 
      \     '\c\<inpos50\>'     : 'inpos20'     , 
      \     '\c\<inpos20\>'     : 'fllwtime1_5' , 
      \   },
      \   {
      \     '\c\<z200\>'  : 'z100', 
      \     '\c\<z100\>'  : 'z50',  
      \     '\c\<z50\>'   : 'z10',  
      \     '\c\<z10\>'   : 'fine', 
      \     '\c\<fine\>'  : 'z200', 
      \   },
      \   {
      \     '\c\<z\d\+\>' : 'z100',
      \   },
      \   {
      \     '\c\<vmax\>'  : 'v7000',
      \     '\c\<v7000\>' : 'v5000',
      \     '\c\<v5000\>' : 'v2500',
      \     '\c\<v2500\>' : 'v1500',
      \     '\c\<v1500\>' : 'v500', 
      \     '\c\<v500\>'  : 'v200', 
      \     '\c\<v200\>'  : 'v100', 
      \     '\c\<v100\>'  : 'v50',  
      \     '\c\<v50\>'   : 'v20',  
      \     '\c\<v20\>'   : 'vmax', 
      \   },
      \   {
      \     '\c\<v\d\+\>' : 'v1500',
      \   },
      \   {
      \     '\c\<vrot50\>'  : 'vrot20',
      \     '\c\<vrot20\>'  : 'vrot10',
      \     '\c\<vrot10\>'  : 'vrot5', 
      \     '\c\<vrot5\>'   : 'vrot2', 
      \     '\c\<vrot2\>'   : 'vrot1', 
      \     '\c\<vrot1\>'   : 'vrot50',
      \   },
      \   {
      \     '\c\<vlin500\>' : 'vlin200',
      \     '\c\<vlin200\>' : 'vlin100',
      \     '\c\<vlin100\>' : 'vlin50', 
      \     '\c\<vlin50\>'  : 'vlin20', 
      \     '\c\<vlin20\>'  : 'vlin10', 
      \     '\c\<vlin10\>'  : 'vlin500',
      \   },
      \ ]

function! RapidUseCustomDictForSwitch(in)
  return    a:in =~ '\c\v^(inpos|stoptime\d_|fllwtime\d_)\d+$'
        \|| a:in =~ '\c\v^(fine|z\d+|v\d+|vmax|vrot\d+|vlin\d+)$'
endfunction

command! RapidSwitch call RapidSwitch()
function! RapidSwitch()
  if RapidUseCustomDictForSwitch(expand('<cword>'))
    silent call switch#Switch({'definitions': b:rapidSwitchFwd})
    silent! call repeat#set(":RapidSwitch\<cr>")
  else
    silent call switch#Switch()
    silent! call repeat#set(":Switch\<cr>")
  endif
endfunction

command! RapidSwitchReverse call RapidSwitchReverse()
function! RapidSwitchReverse()
  if RapidUseCustomDictForSwitch(expand('<cword>'))
    silent call switch#Switch({'definitions': b:rapidSwitchBwd})
    silent! call repeat#set(":RapidSwitchReverse\<cr>")
  else
    silent call switch#Switch({'reverse': 1})
    silent! call repeat#set(":SwitchReverse\<cr>")
  endif
endfunction

nnoremap <silent> <Plug>RapidSwitchFwd :RapidSwitch<cr>
nnoremap <silent> <Plug>RapidSwitchBwd :RapidSwitchReverse<cr>
nmap gs <Plug>RapidSwitchFwd
nmap ga <Plug>RapidSwitchBwd

let b:switch_custom_definitions =
      \ [
      \   {
      \     '\c\<true\>'  : 'FALSE',
      \     '\c\<false\>' : 'TRUE',
      \   },
      \   {
      \     '\c\<high\>' : 'low',
      \     '\c\<low\>'  : 'high',
      \   },
      \   {
      \     '\c\(not\)\@3<! (' : ' not (',
      \     '\c not ('         : ' (',
      \   },
      \   {
      \     '\c\<and\>' : 'or',
      \     '\c\<or\>'  : 'xor',
      \     '\c\<xor\>' : 'and',
      \   },
      \   {
      \     '='  : '>=',
      \     '>=' : '<=',
      \     '<=' : '<>',
      \     '<>' : '=',
      \   },
      \   {
      \     '\c\<div\>' : 'MOD',
      \     '\c\<mod\>' : 'DIV',
      \   },
      \   {
      \     '\c\v^(\s*)<elseif>\s*$'        : '\1else',
      \     '\c\v^(\s*)<else>\s*$'        : '\1elseif ',
      \     '\c\v^(\s*)<elseif>([^!]+)'        : '\1else !\2%',
      \     '\c\v^(\s*)<else>\s?(\s*)!?(.*)\%'  : '\1elseif\2\3',
      \   },
      \   {
      \     '\c\v^(\s*)<case>([^!]*):'            : '\1default: !\2%',
      \     '\c\v^(\s*)<default>\s*:(\s*!.*\%)?'  : '\1endtest\2',
      \     '\c\v^(\s*)<endtest>\s?(\s*)!(.*)\%'  : '\1case\2\3:',
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
      \     '\c\v^(\s*Move)J>'                               : '\1AbsJ',
      \     '\c\v^(\s*Move)AbsJ>'                            : '\1L',
      \     '\c\v^(\s*Move|\s*Trigg)J(IOs|AO|DO|GO|Sync)?>'  : '\1L\2',
      \     '\c\v^(\s*Move|\s*Trigg)L(IOs|AO|DO|GO|Sync)?>'  : '\1C\2',
      \     '\c\v^(\s*Move|\s*Trigg)C(IOs|AO|DO|GO|Sync)?>'  : '\1J\2',
      \   },
      \   {
      \     '\c\v^(\s*Arc)(Adapt|Calc)?([CL])([12])?Start>' : '\1\2\3\4',
      \     '\c\v^(\s*Arc)(Adapt|Calc)?([CL])([12])?>'      : '\1\2\3\4End',
      \     '\c\v^(\s*Arc)(Adapt|Calc)?([CL])([12])?End>'   : '\1\2\3\4Start',
      \   },
      \   {
      \     '\c\v^(\s*)(Nut|SpotM?|Calib|DaProcM)L' : '\1\2J',
      \     '\c\v^(\s*)(Nut|SpotM?|Calib|DaProcM)J' : '\1\2L',
      \   },
      \   {
      \     '\c\v^(\s*)(Cap|Disp|EGMMove|Paint|Search)L' : '\1\2C',
      \     '\c\v^(\s*)(Cap|Disp|EGMMove|Paint|Search)C' : '\1\2L',
      \   },
      \   {
      \     '\c\<IndAMove\>'  : 'IndCMove',
      \     '\c\<IndCMove\>'  : 'IndDMove',
      \     '\c\<IndDMove\>'  : 'IndRMove',
      \     '\c\<IndRMove\>'  : 'IndAMove',
      \   },
      \   {
      \     '\c\v^(\s*SMove|\s*STrigg)J(DO|GO|Sync)?' : '\1L\2',
      \     '\c\v^(\s*SMove|\s*STrigg)L(DO|GO|Sync)?' : '\1J\2',
      \   },
      \   {
      \     '\c\<PathRecMoveBwd\>' : 'PathRecMoveFwd',
      \     '\c\<PathRecMoveFwd\>' : 'PathRecMoveBwd',
      \   },
      \   {
      \     '\c\<StartMove\>'       : 'StartMoveRetry',
      \     '\c\<StartMoveRetry\>'  : 'StopMove',
      \     '\c\<StopMove\>'        : 'StopMoveReset',
      \     '\c\<StopMoveReset\>'   : 'StartMove',
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

" nnoremap <F6> :syntax on<bar>normal mzgg=G`z<cr>:syntax off<cr>

" vim:sw=2 sts=2 et fdm=marker fmr={{{,}}}
