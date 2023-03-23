" Vim syntax file
" Language: Kawasaki AS-language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.0
" Last Change: 23. Mar 2023
"
" Note to self:
" for testing perfomance
"     open a 1000 lines file.
"     :syntime on
"     G
"     hold down CTRL-U until reaching top
"     :syntime report

" Init {{{
if exists("b:current_syntax")
  finish
endif

let s:keepcpo = &cpo
set cpo&vim

" if colorscheme is tortus(less)? asGroupName defaults to 1
if get(g:, 'colors_name', " ") =~ '\<tortus'
      \&& !exists("g:asGroupName")
  let g:asGroupName=1 
endif
" asGroupName defaults to 0 if it's not initialized yet or 0
if !get(g:, "asGroupName", 0)
  let g:asGroupName = 0 
endif

syn case ignore
syn spell notoplevel
" }}} init

" Comment and Folding {{{ 

" Special Comment

" TODO Comment
syn keyword asTodo contained TODO FIXME XXX
highlight default link asTodo Todo

" Debug Comment
syn keyword asDebug contained DEBUG
highlight default link asDebug Debug

" Comment
syn match asComment /;.*$/ contains=asTodo,asDebug,@Spell
highlight default link asComment Comment

" }}} Comment and Folding 

" Header {{{
syn match asHeader /^\.\w\+/
highlight default link asHeader PreProc
" }}} Header

" Operator {{{
" Boolean operator
syn keyword asBoolOperator AND OR XOR NAND NOT BAND BOR BXOR
highlight default link asBoolOperator Operator
" Arithmetic operator
syn match asArithOperator /[+-]/
syn match asArithOperator /[*/]/
highlight default link asArithOperator Operator
" Compare operator
syn match asCompOperator /[<>=]/
highlight default link asCompOperator Operator
" }}} Operator

" Delimiter {{{
syn match asDelimiter /[#$&:\[\](),\\]/
highlight default link asDelimiter Delimiter
" }}} Delimiter

" Constant values {{{
" Boolean
syn keyword asBoolean NULL
syn keyword asBoolean FALSE OFF ON TRUE
highlight default link asBoolean Boolean
" Binary integer
syn match asBinaryInt /^b[01]\+'/
highlight default link asBinaryInt Number
" Hexadecimal integer
syn match asHexInt /^h[0-9a-fA-F]\+'/
highlight default link asHexInt Number
" Integer
syn match asInteger /\W\@1<=[+-]\?\d\+/ contains=asArithOperator
highlight default link asInteger Number
" Float
syn match asFloat /\v\W@1<=[+-]?\d+\.?\d*%(\s*[eE][+-]?\d+)?/
highlight default link asFloat Float
" String
syn region asString start=/"/ end=/"/ oneline contains=@Spell
highlight default link asString String
" }}} Constant values

" Predefined Structure {{{
syn keyword asStructure ADC
syn keyword asStructure CNTADC
syn keyword asStructure COLCALOFF COLCALON COLCOLDOFF COLCOLDON COLINIT COLMVOFF COLMVON COLR COLRJ COLRJOFF COLRJON COLROFF COLRON COLSTATE COLT COLTJ COLTJOFF COLTJON COLTOFF COLTON
syn keyword asStructure CVC1MOVE CVC2MOVE CVCOOPJT CVDELAY CVENCSGN CVFLS2 CVFMAX CVFNONPITCH CVFPH2 CVGAIN CVHMOVE CVLAPPRO CVLDEPART CVLMOVE CVMAXSPD CVPITCH CVPOS CVPOS2 CVRESET CVSCALE CVSET CVSIMU CVSMAX CVSPEED CVSWITCH CVWAIT CVXYSIGN
syn keyword asStructure DAOFFSET OUTDA
syn keyword asStructure PMODEND PMODLIMIT PMODPRINTDATA PMODSTART PMODTXYZ PMODXYZ PMOD_LINSP PMOD_ROTSP
syn keyword asStructure SETCCVSLOPE SETCOLTHID SETLCVSLOPE SETOUTDA SIGAPPRO SIGDEPART SIGPOINT
syn keyword asStructure TCP_ACCEPT TCP_CLOSE TCP_CONNECT TCP_END_LISTEN TCP_ISLINK TCP_LISTEN TCP_RECV TCP_SEND TCP_STATUS
syn keyword asStructure TRQNM
syn keyword asStructure UDP_RECVFROM UDP_SENDTO
syn keyword asStructure ZCNTUP
syn keyword asStructure CBS_TOOLCHG CBS_AUXTOOL1 CBS_BASE
highlight default link asStructure Structure
" }}} Predefined Structure and Enum

" Statements, keywords et al {{{
" keywords
syn keyword asStatement ABORT ABOVE ABS.SPEED ABS ABSDRIVE ACCEL ACCEPT ACCURACY AFTER.WAIT.TMR ALIGN ALLERESET ALLROB_SPSET ALONE ALWAYS ASC ATAN2 AVE_TRANS
syn keyword asStatement AUTOSTART.PC AUTOSTART2.PC AUTOSTART3.PC AUTOSTART4.PC AUTOSTART5.PC AUTOSTART6.PC AUTOSTART7.PC AUTOSTART8.PC
syn keyword asStatement BASE BATCHK BELOW BITS BITS32 BREAK BSPEED BY
syn keyword asStatement CALL CBSMON_EXTDISABLE CBSMON_EXTENABLE CBSMON_SETDEVICE CCENTER CHECK.HOLD CHSUM CLAMP CLOSE CLOSEI CLOSES CM/MIN CM/S COM CONF_VARIABLE CONTINUE COOP.DRIVE.EX1 COOP.DRIVE.EX2 COOPSTATUS COPY COS CP CS CSHIFT CURLIM CURLIMM CURLIMP CVRESETSIG_DELAY CYCLE.STOP
syn keyword asStatement DECEL DECMPCOLR DECMPCOLRJ DECOMPOSE DEFSIG DEG/MIN DEG/S DELAY DELETE DEST DEST_CIRINT DEXT DIRECTORY DISP.EXESTEP DISPIO_01 DISTANCE DIVIDE.TPKEY_S DLYSIG DRAW DRIVE DWRIST DX DY DZ
syn keyword asStatement EDIT ENA_TOOLSHAPE ENC_TEMP ENCCHK_EMG ENCCHK_PON ENV_DATA ENV2_DATA ENVCHKRATE ERESET ERR_ALLROBSTOP ERRLOG ERROR ERRSTART.PC EXECUTE EXTCALL
syn keyword asStatement EXISTCHAR EXISTDATA EXISTINTEGER EXISTJOINT EXISTLOCALCHAR EXISTLOCALINTEGER EXISTLOCALJOINT EXISTLOCALREAL EXISTLOCALTRANS EXISTPGM EXISTREAL EXISTTRANS
syn keyword asStatement FB_PORT_ASSIGN FB_RESET_ABCC FB_S_CCL FB_SET_WORD FB_SIG_ORDER FFRESET FFSET FFSET_STATUS FINE FLOWRATE FRAME FREE
syn keyword asStatement GETENCTEMP GETLLMIT GETULIMIT GUNOFF GUNOFFTIMER GUNON GUNONTIMER
syn keyword asStatement HALT HELP/DO HELP/F HELP/MC HELP/M HELP/PPC HELP/P HELP/SW HELP HERE HOLD HOLD.STEP HOME HSENSE HSENSESET HSETCLAMP
syn keyword asStatement ID IFAKEY IFPDISP IFPLABEL IFPTITLE IFPWOVERWRITE IFPWPRINT IGNORE INPUT INRANGE INS_POWER INSERT_NO_CONFIRM INSTR INT INTERP_FTOOL INTFCHK INVALID.TPKEY_S IO IPEAKCLR IPEAKLOG IQARM
syn keyword asStatement JUMP
syn keyword asStatement KILL
syn keyword asStatement L3ACCURACY L3ARMSLOWMODE L3ARMSLOWRATE L3ARMSLOWSET L3JNT L3LINKSLOWMODE L3LINKSLOWRATE L3LINKSLOWSET L3SPEED L3TOOL L3TRN
syn keyword asStatement LANGUAGE LEFTY LEN LIST LLIMIT LOAD/F LOAD/Q LOAD LOCK LSTRACE
syn keyword asStatement MASTER MAXINDEX MAXVAL MC MESSAGES MHERE MININDEX MINVAL MM/MIN MM/S MNTINFOGET MOD MON_SPEED MON_TWAIT MSPEED MSPEED2 MSTEP MVWAIT
syn keyword asStatement NCHOFF NCHON NEXT NLOAD NO_SJISCONV NOEXIST_SET_L NOEXIST_SET_R NOEXIST_SET_S
syn keyword asStatement ONE ONI OPEINFO OPEINFOCLR OPEN OPENI OPENS OPLOG OUTDA OUTPUT OX.PREOUT OXZERO
syn keyword asStatement PALMODE PAUSE PCABORT PCCONTINUE PCEND PCENDMSG_MASK PCEXECUTE PCKILL PCSCAN PCSTATUS PCSTEP PI PLCAIN PLCAOUT PNL_CYCST PNL_ERESET PNL_MPOWER POWER PREFETCH.SIGINS PRIME PRINT PRIORITY PROG.DATE PROMPT PULSE
syn keyword asStatement POINT/10 POINT/11 POINT/12 POINT/13 POINT/14 POINT/15 POINT/16 POINT/17 POINT/18 POINT/7 POINT/8 POINT/9 POINT/A POINT/EXT POINT/OAT POINT/O POINT/T POINT/X POINT/Y POINT/Z POINT
syn keyword asStatement QTOOL
syn keyword asStatement RANDOM REC REC_ACCEPT REFFLTRESET REFFLTSET REFFLTSET_STATUS RELAX RELAXI RELAXS RENAME REP_ONCE REP_ONCE.RPS_LAST REPEAT REPEAT RESET RESTRACE RETURN RETURNE RGSO RIGHTY ROBNET_TCHMASTER ROBNETID ROBNETROBOT ROBNETSIG ROUND RPS RSIGCORRECT RSIGPOINT RSIGRANGE RUN RUNMASK RX RY RZ
syn keyword asStatement S_HERE
syn keyword asStatement SAVE/ALLLOG SAVE/A SAVE/ELOG SAVE/FULL SAVE/L SAVE/OLOG SAVE/OPLOG SAVE/P SAVE/ROB SAVE/R SAVE/STG SAVE/SYS SAVE/S SAVE
syn keyword asStatement SC2RECEIVE SC2SEND SCALL SCASE SCNT SCNTRESET SCPROTOCOL SCREEN SCSETSIO
syn keyword asStatement SET_MAXTOOLSHAPENUM SET_TOOLSHAPE SET2HOME SETENCTEMP_THRES SETHOME SETOUTDA SETPICK SETPLACE SETTIME SETTRACE
syn keyword asStatement SFLK SFLP SHIFT SHUTDOWN
syn keyword asStatement SIG SIG2 SIGMON_TEACH SIGNAL SIGRSTCONF
syn keyword asStatement SIN SINGULAR SJUMP SLAVE SLOAD SLOW SLOW_REPEAT SLOW_START SOUT SPEED SQRT STABLE STAT_ON_KYBD STATUS STEP STG_CHCOMBI STG_SAMPLING STG_START STG_STOP STIM STOP STP_ONCE STPNEXT
syn keyword asStatement STRGCLR STRGSET STRGSETIO STRGSTART STRGSTOP STRTOPOS STRTOVAL
syn keyword asStatement SVALUE SWAIT SYSDATA SYSINIT SYSINIT/SW SYSINIT/U
syn keyword asStatement TASK TASKNO TDRAW TEACH_LOCK TILL TIME TIMER TOOL TOOLSHAPE TOUCH.ENA TOUCHST.ENA TPKEY_A TPKEY_S TPLIGHT TPSPEED.RESET TRACE TRADD TRANS TRIGGER TRSUB TWAIT TYPE
syn keyword asStatement ULIMIT UNTIL
syn keyword asStatement USB_COPY USB_FDEL USB_FDIR USB_LOAD USB_MKDIR USB_RENAME USB_SAVE/A USB_SAVE/ALLLOG USB_SAVE/ELOG USB_SAVE/FULL USB_SAVE/L USB_SAVE/OPLOG USB_SAVE/P USB_SAVE/R USB_SAVE/ROB USB_SAVE/S USB_SAVE/STG USB_SAVE/SYS USB_SAVE
syn keyword asStatement USE_ISO8859_5 UTIMER UWRIST
syn keyword asStatement VAL VALUE
syn keyword asStatement WAIT WAITREL_AUTO WEIGHT WHERE WHICHTASK WS.ZERO WS_COMPOFF 
syn keyword asStatement XD XFER XP XQ XS XY
syn keyword asStatement ZALLPGKILL ZAREASLOWMODE ZAREASLOWRATE ZAREASLOWSET ZINTFTOOLMDL ZINTFXLINK2BRAD ZINTFXLINK2RAD ZINTFXLINKRAD ZL3LINK2BOX ZPOWER ZRMTSET ZRMTSET2 ZSIGMAP ZSIGMAP_CLEAR ZSIGSPEC ZSOFT_EXCHANGE ZSOFT_EXCHANGE_AUTO ZZERO

highlight default link asStatement Statement
" Conditional
syn keyword asConditional IF THEN ELSE ELSEIF END CASE OF VALUE ANY
highlight default link asConditional Conditional
" Repeat
syn keyword asRepeat FOR TO WHILE DO
highlight default link asRepeat Repeat
" Label
syn keyword asLabel GOTO
syn match asLabel /^\s*\w\+:\ze\s*\%(;.*\)\?$/
highlight default link asLabel Label
" }}} Statements, keywords et al

" special keywords for movement commands {{{
syn keyword asMovement BRAKE C2MOVE C2MOVE CVJMOVE CVL3LMOVE CVMLJMOVE CVMLL3LMOVE FJMOVE FLMOVE HMOVE JMOVE L3C1MOVE L3C2MOVE L3LMOVE LMOVE MLC1MOVE MLC2MOVE MLJMOVE MLLMOVE MLZL3LMOVE MRC1MOVE MRC2MOVE MRLMOVE XMOVE
syn keyword asMovement HOME
syn keyword asMovement JAPPRO JDEPART LAPPRO LDEPART 
if g:asGroupName
  highlight default link asMovement Movement
else
  highlight default link asMovement Special
endif
" }}} special keywords for movement commands

" BuildInFunction {{{
syn keyword asFunction CHR DATE DECODE ENCODE ERROR ERRORS LEFT MID RIGHT SPACE TIME TIME_MS REPLACE STR_ID STR_ID2 SYSDATA ERRLOG
highlight default link asFunction Function
" }}} BuildInFunction

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo

let b:current_syntax = "kawasaki_as"
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker

