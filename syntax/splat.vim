" Vim syntax file
" Language: Splat
" Maintainer: Samson Danziger
" Latest Revision: 2016-04-28

if exists("b:current_syntax")
    finish
endif

syntax keyword splatFunction    split head tail show showln
syntax keyword splatFunction    lstend strend

syntax keyword splatConditional if else
syntax keyword splatKeyword     let
syntax keyword splatKeyword     function nextgroup=splatType skipwhite 
syntax keyword splatType        number boolean string list nextgroup=splatType,splatVariable skipwhite

syntax keyword splatStdin     stdin
syntax match   splatApply     '\v#'

syntax match splatNumber    '\v\-?\d\+(\.\d*)?'
syntax match splatString    '\v"[a-zA-Z0-9]*"'
syntax match splatBoolean   '\v(true|false)'
syntax match splatList      '\v\[\]'
syntax match splatListSep   '\v\:\:'

syntax match splatVariable  '\v\w[\w\d]+'

syntax match splatOperator  '\v(\+|\-|\*|\/|\%|\^)'
syntax match splatBooleanOperator '\v(and|or|not)'
syntax match splatComparison '\v((\<|\>)\=?|(\=|\!)\=)'

syntax region splatComment start='<|' end='|>'

highlight link splatFunction Function
highlight link splatConditional Conditional 
highlight link splatKeyword Keyword
highlight link splatComment Comment 
highlight link splatType Type 

highlight link splatNumber Float
highlight link splatString String 
highlight link splatBoolean Boolean
highlight link splatList Constant
highlight link splatListSep SpecialChar

highlight link splatVariable Indentifier

highlight link splatStdin   Constant 
highlight link splatApply   SpecialChar

highlight link splatOperator Operator
highlight link splatBooleanOperator Keyword 
highlight link splatComparison Operator

let b:current_syntax = "splat"