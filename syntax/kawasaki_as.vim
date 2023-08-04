" Vim syntax file
" Language: Kawasaki AS-language
" Maintainer: Patrick Meiser-Knosowski <knosowski@graeffrobotics.de>
" Version: 1.0.2
" Last Change: 03. Aug 2023
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

" AS does ignore case
syn case ignore
" take . into keyword (syntax only)
syn iskeyword @,48-57,_,192-255,#,$,.,/
" spell checking
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
syn match asArithOperator /[*/^]/
highlight default link asArithOperator Operator
" Compare operator
syn match asCompOperator /[<>=]/
highlight default link asCompOperator Operator
" }}} Operator

" Delimiter {{{
syn match asDelimiter /[:\[\](),\\]/
highlight default link asDelimiter Delimiter
" }}} Delimiter

" Constant values {{{
" General
syn keyword asConstValue NULL PI 
highlight default link asConstValue Constant
" Boolean
syn keyword asBoolean ON OFF TRUE FALSE 
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

" Predefined structures and switches {{{
syn keyword asSwitches ABS.SPEED AFTER.WAIT.TMR AUTOSTART.LSQ
syn keyword asSwitches CBS_AUXTOOL1 CBS_BASE CBS_REFLECT_CBSTOOL CBS_TOOLCHG
syn keyword asSwitches CHECK.HOLD COINC_DISPONCE_CHK CONF_VARIABLE CP CS CVMOVE.NOBREAK CYCLE.STOP
syn keyword asSwitches DEST_CIRINT DISP.EXESTEP DISPIO_01 DIVIDE.TPKEY_S
syn keyword asSwitches EB2MATCIRC EBMATCIRC ERROR ERROUT_TEACH ERRSTART.PC
syn keyword asSwitches FB_DISCON_ERR FB_UNSIGNED_WORD FLEXCOMP FLOWRATE FLOWRATE2 FLOWRATE3 FLOWRATE4
syn keyword asSwitches HOLD.STEP
syn keyword asSwitches IFAKEY INSERTSTEP_CURRENT INSERT_NO_CONFIRM INTERP_FTOOL INVALID.TPKEY_S
syn keyword asSwitches KANJI_DISPLAY KLGCNT_SAVE
syn keyword asSwitches LIST_VERTICAL LOCAL_VAR_DISP
syn keyword asSwitches MESSAGES MODIFYSTEP_CURRENT
syn keyword asSwitches NOPENABLE NO_SJISCONV
syn keyword asSwitches OPELV_RESET OUT_RPSCODE_MAINPG OVERDRIVE_NOBREAK OX.PREOUT OXZERO
syn keyword asSwitches PCENDMSG_MASK PGFILE_AUTO_RECOVER PGNAME_DISP PLC.CHECK
syn keyword asSwitches PNL_CYCST PNL_ERESET PNL_MPOWER
syn keyword asSwitches POWER PREFETCH.SIGINS PREOUTSIG.VAR PROG.CYC PROG.DATE
syn keyword asSwitches QTOOL
syn keyword asSwitches RECORD_NO_CONFIRM REPEAT REP_ONCE REP_ONCE.RPS_LAST REP_SINGULAR RGSO RPS RUN
syn keyword asSwitches SCREEN SF_OPEN_ERROR SIGMON_TEACH SIGRSTCONF SINGULAR SLOW_REP_MM SLOW_START STAT_ON_KYBD STP_ONCE
syn keyword asSwitches TCH_SINGULAR TEACH_LOCK TOUCH.ENA TOUCHST.ENA TPKEY_A TPKEY_S TPSPEED.RESET TREND_MANAGER TRIGGER
syn keyword asSwitches UDP_EMSG UDP_SEND_NOBIND USE_ISO8859_5
syn keyword asSwitches VISION_OPERATE
syn keyword asSwitches WAITREL_AUTO
syn keyword asSwitches WS.ZERO WS_COMPOFF
highlight default link asSwitches Structure
" stuff from KIDE
syn keyword asStructure ADC
syn keyword asStructure CNTADC
syn keyword asStructure COLCALOFF COLCALON COLCOLDOFF COLCOLDON COLINIT COLMVOFF COLMVON COLR COLRJ COLRJOFF COLRJON COLROFF COLRON COLSTATE COLT COLTJ COLTJOFF COLTJON COLTOFF COLTON
syn keyword asStructure CVC1MOVE CVC2MOVE CVCOOPJT CVDELAY CVENCSGN CVFLS2 CVFMAX CVFNONPITCH CVFPH2 CVGAIN CVLMOVE CVMAXSPD CVPITCH CVPOS CVPOS2 CVRESET CVSCALE CVSET CVSIMU CVSMAX CVSPEED CVSWITCH CVWAIT CVXYSIGN
syn keyword asStructure DAOFFSET OUTDA
syn keyword asStructure PMODEND PMODLIMIT PMODPRINTDATA PMODSTART PMODTXYZ PMODXYZ PMOD_LINSP PMOD_ROTSP
syn keyword asStructure SETCCVSLOPE SETCOLTHID SETLCVSLOPE SETOUTDA SIGAPPRO SIGDEPART SIGPOINT
syn keyword asStructure TCP_ACCEPT TCP_CLOSE TCP_CONNECT TCP_END_LISTEN TCP_ISLINK TCP_LISTEN TCP_RECV TCP_SEND TCP_STATUS
syn keyword asStructure UDP_RECVFROM UDP_SENDTO
syn keyword asStructure ZCNTUP
highlight default link asStructure Structure
" }}} Predefined Structure and Enum

" Statements, keywords et al {{{
" keywords
syn keyword asStatement ABORT ABOVE ABSDRIVE ACCEL ACCEPT ACCURACY ALLERESET ALLROB_SPSET ALONE ALWAYS
syn keyword asStatement BATCHK BELOW BREAK BSPEED BY
syn match asStatement /\c\v^\s*BASE>/
syn match asStatement /\c\v^\s*BITS>/
syn match asStatement /\c\v^\s*BITS32>/
syn keyword asStatement CALL CBSMON_EXTDISABLE CBSMON_EXTENABLE CBSMON_SETDEVICE CHSUM CLAMP CLOSE CLOSEI CLOSES CM/MIN CM/S COM CONTINUE COOP.DRIVE.EX1 COOP.DRIVE.EX2 COOPSTATUS COPY CURLIM CVRESETSIG_DELAY 
syn keyword asStatement DECEL DECMPCOLR DECMPCOLRJ DECOMPOSE DEFSIG DEG/MIN DEG/S DELAY DELETE DIRECTORY DLYSIG DWRIST 
syn keyword asStatement EDIT ENA_TOOLSHAPE ENC_TEMP ENCCHK_EMG ENCCHK_PON ENV_DATA ENV2_DATA ERESET ERR_ALLROBSTOP ERRLOG EXECUTE EXTCALL
syn match asStatement /\c\v^\s*ENVCHKRATE>/
syn keyword asStatement FHERE FTOOL FB_PORT_ASSIGN FB_RESET_ABCC FB_S_CCL FB_SET_WORD FB_SIG_ORDER FFRESET FFSET FFSET_STATUS FINE FREE
syn keyword asStatement GETLLMIT GETULIMIT GUNOFF GUNOFFTIMER GUNON GUNONTIMER
syn keyword asStatement HALT HELP HELP/DO HELP/F HELP/M HELP/MC HELP/P HELP/PPC HELP/SW HOLD HSENSE HSENSESET HSETCLAMP
syn match asStatement /\c\v^\s*HERE>/
syn keyword asStatement ID IFPDISP IFPLABEL IFPTITLE IFPWOVERWRITE IFPWPRINT IGNORE INPUT INS_POWER INTFCHK IO IO/E IPEAKCLR IPEAKLOG 
syn keyword asStatement JUMP
syn keyword asStatement KILL
syn keyword asStatement L3ACCURACY L3ARMSLOWMODE L3ARMSLOWRATE L3ARMSLOWSET L3JNT L3LINKSLOWMODE L3LINKSLOWRATE L3LINKSLOWSET L3SPEED L3TOOL L3TRN
syn keyword asStatement LANGUAGE LEFTY LIST LIST/P LIST/L LIST/R LIST/S LLIMIT LOAD/F LOAD/Q LOAD LOCK LSTRACE
syn keyword asStatement MASTER MC MHERE MM/MIN MM/S MNTINFOGET MOD MON_TWAIT MSTEP MVWAIT
syn keyword asStatement NCHOFF NCHON NEXT NLOAD NOEXIST_SET_L NOEXIST_SET_R NOEXIST_SET_S
syn keyword asStatement ONE ONI OPEINFO OPEINFOCLR OPEN OPENI OPENS OPLOG OUTDA OUTPUT 
syn keyword asStatement PALMODE PAUSE PCABORT PCCONTINUE PCEND PCEXECUTE PCKILL PCSCAN PCSTATUS PCSTEP PLCAIN PLCAOUT PRIME PRINT PROMPT PULSE
syn keyword asStatement POINT/10 POINT/11 POINT/12 POINT/13 POINT/14 POINT/15 POINT/16 POINT/17 POINT/18 POINT/7 POINT/8 POINT/9 POINT/A POINT/EXT POINT/OAT POINT/O POINT/T POINT/X POINT/Y POINT/Z POINT
syn keyword asStatement REC REC_ACCEPT REFFLTRESET REFFLTSET REFFLTSET_STATUS RELAX RELAXI RELAXS RENAME RESET RESTRACE RETURN RETURNE RIGHTY 
syn keyword asStatement ROBNET_TCHMASTER ROBNETID ROBNETROBOT ROBNETSIG RSIGCORRECT RSIGPOINT RSIGRANGE RUNMASK 
syn match asStatement /\c\v^\s*REPEAT>/
syn keyword asStatement S_HERE
syn keyword asStatement SAVE/ALLLOG SAVE/A SAVE/ELOG SAVE/FULL SAVE/L SAVE/OLOG SAVE/OPLOG SAVE/P SAVE/ROB SAVE/R SAVE/STG SAVE/SYS SAVE/S SAVE
syn keyword asStatement SC2RECEIVE SC2SEND SCALL SCASE SCNT SCNTRESET SCPROTOCOL SCSETSIO
syn keyword asStatement SET_MAXTOOLSHAPENUM SET_TOOLSHAPE SET2HOME SETENCTEMP_THRES SETHOME SETOUTDA SETPICK SETPLACE SETTIME SETTRACE
syn keyword asStatement SFLK SFLP SHUTDOWN
syn keyword asStatement SIGNAL 
syn keyword asStatement SJUMP SLAVE SLOAD SLOW SLOW_REPEAT SOUT SPEED STABLE STATUS STEP STG_CHCOMBI STG_SAMPLING STG_START STG_STOP STIM STOP STPNEXT
syn keyword asStatement STRGCLR STRGSET STRGSETIO STRGSTART STRGSTOP 
syn keyword asStatement SVALUE SWAIT SYSDATA SYSINIT SYSINIT/SW SYSINIT/U
syn match asStatement /\c\v^\s*SWITCH>/
syn keyword asStatement TASKNO TILL TIME TOOLSHAPE TPLIGHT TRACE TWAIT TYPE
syn match asStatement /\c\v^\s*TIMER>/
syn match asStatement /\c\v^\s*TOOL>/
syn keyword asStatement ULIMIT
syn keyword asStatement USB_COPY USB_FDEL USB_FDIR USB_LOAD USB_MKDIR USB_RENAME USB_SAVE/A USB_SAVE/ALLLOG USB_SAVE/ELOG USB_SAVE/FULL USB_SAVE/L USB_SAVE/OPLOG USB_SAVE/P USB_SAVE/R USB_SAVE/ROB USB_SAVE/S USB_SAVE/STG USB_SAVE/SYS USB_SAVE
syn keyword asStatement UWRIST
syn match asStatement /\c\v^\s*UTIMER>/
syn keyword asStatement VALUE
syn keyword asStatement WAIT WEIGHT WHERE 
syn keyword asStatement XD XFER XP XQ XS XY
syn keyword asStatement ZALLPGKILL ZAREASLOWMODE ZAREASLOWRATE ZAREASLOWSET ZINTFTOOLMDL ZINTFXLINK2BRAD ZINTFXLINK2RAD ZINTFXLINKRAD ZL3LINK2BOX ZPOWER ZRMTSET ZRMTSET2 ZSIGMAP ZSIGMAP_CLEAR ZSIGSPEC ZSOFT_EXCHANGE ZSOFT_EXCHANGE_AUTO ZZERO

highlight default link asStatement Statement
" Conditional
syn keyword asConditional IF THEN ELSE ELSEIF END CASE SCASE OF VALUE SVALUE ANY
highlight default link asConditional Conditional
" Repeat
syn keyword asRepeat FOR TO WHILE DO UNTIL
highlight default link asRepeat Repeat
" Label
syn keyword asLabel GOTO
" syn match asLabel /^\s*\w\+:\ze\s*\%(;.*\)\?$/
highlight default link asLabel Label
" }}} Statements, keywords et al

" special keywords for movement commands {{{
syn keyword asMovement ALIGN BRAKE C2MOVE C2MOVE CVLDEPART CVJMOVE CVLAPPRO CVL3LMOVE CVMLJMOVE CVMLL3LMOVE DRIVE FJMOVE FLMOVE CVHMOVE HMOVE JMOVE L3C1MOVE L3C2MOVE L3LMOVE LMOVE MLC1MOVE MLC2MOVE MLJMOVE MLLMOVE MLZL3LMOVE MRC1MOVE MRC2MOVE MRLMOVE XMOVE
syn keyword asMovement HOME
syn keyword asMovement DRAW TDRAW 
syn keyword asMovement JAPPRO JDEPART LAPPRO LDEPART 
if g:asGroupName
  highlight default link asMovement Movement
else
  highlight default link asMovement Special
endif
" }}} special keywords for movement commands

" BuildInFunction {{{
syn keyword asBuildInFunction contained ABS ASC ATAN2 AVE_TRANS 
syn keyword asBuildInFunction contained BASE BITS BITS32 CCENTER $CHR COS CSHIFT CURLIMM CURLIMP 
syn keyword asBuildInFunction contained $DATE $DECODE DEST #DEST DEXT DISTANCE DX DY DZ
syn keyword asBuildInFunction contained $ENCODE ERROR $ERROR $ERRORS $ERRLOG ENVCHKRATE $LEFT 
syn keyword asBuildInFunction contained EXISTCHAR EXISTDATA EXISTINTEGER EXISTJOINT EXISTLOCALCHAR EXISTLOCALINTEGER EXISTLOCALJOINT EXISTLOCALREAL EXISTLOCALTRANS EXISTPGM EXISTREAL EXISTTRANS
syn keyword asBuildInFunction contained FRAME GETENCTEMP #HOME INRANGE INSTR INT IQARM LEN MAXINDEX MAXVAL $MID MININDEX MINVAL RIGHT SWITCH TASK 
syn keyword asBuildInFunction contained $TIME TIMER TIME_MS #PPOINT REPLACE $RIGHT ROUND RX RY RZ 
syn keyword asBuildInFunction contained SHIFT SIG SIG2 SIN $SPACE SQRT STR_ID STR_ID2 STRTOPOS STRTOVAL SYSDATA $SYSDATA TRADD TRANS TRQNM TRSUB UTIMER VAL 
syn keyword asBuildInFunction HERE #HERE MSPEED MSPEED2 PRIORITY TOOL WHICHTASK RANDOM 
if g:asGroupName
  highlight default link asBuildInFunction BuildInFunction
else
  highlight default link asBuildInFunction Function
endif
" }}} BuildInFunction

" Function {{{
syn match asFunction /[a-zA-Z_][a-zA-Z0-9_.]* *(/me=e-1 contains=asBuildInFunction
highlight default link asFunction Function
" }}} Function

" Error {{{
syn match asErrorIdentifierNameTooLong /\w\{16,}/ containedin=ALLBUT,asComment
highlight default link asErrorIdentifierNameTooLong Error

" }}}

" Finish {{{
let &cpo = s:keepcpo
unlet s:keepcpo

let b:current_syntax = "kawasaki_as"
" }}} Finish

" vim:sw=2 sts=2 et fdm=marker

