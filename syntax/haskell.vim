"my own additional customizations for haskell syntax highlighting
"Author: Viacheslav Lotsmanov


if exists("b:current_syntax") ||
\ (exists('g:default_haskell_syntax') && g:default_haskell_syntax == 1)
	finish
endif

" parent
let s:path = expand('<sfile>:p:h:h') . "/haskell-vim-proto/vim/syntax/haskell.vim"
exec "source " . s:path
unlet s:path


sy match hs_TypeDeclaration "\v(\s|^)@<=(::|∷)(\s|$)@="
sy match hs_TypeDeclNext "\v(\s|^)@<=(-\>|→)(\s|$)@="
sy match hs_TypeDeclConstraint "\v(\s|^)@<=(\=\>|⇒)(\s|$)@="
sy match hs_EqualsSymbol "\v(\s|^)@<=\=(\s|$)@="
sy match hs_MonadExtract "\v\s@<=(\<-|←)(\s|$)@="

sy match hs_NothingStuff "\v(\(\)|<undefined>)"
sy match hs_BackQuotesOperator "\v`[a-zA-Z0-9_'.]+`"

" custom fork from parent to fix highlight bug
" when use infix functions inside ViewPatterns.
sy match hs_My_InfixFunctionName "^\S[^=(]*`[a-z_][^`]*`"me=e-1 contained
	\ contains=hs_HighliteInfixFunctionName,hsType,hsConSym,hsVarSym,hsString,hsCharacter
" overwritten from parent
" (added `hs_EqualsSymbol` and `hs_NothingStuff` to `contains`)
" WARN it is blocked to fix `module` highlight when some explicitly exported
"      operator contains equality symbol (`=`).
sy region hs_Function start="^\(module\|\s*{-\)\@!["'a-zA-Z_([{]\(\(.\&[^=]\)\|\(\n\s\)\)*=" end="\(\s\|\n\|\w\|[([]\)"
	\ contains=hs_OpFunctionName,hs_InfixOpFunctionName,hs_My_InfixFunctionName,hs_FunctionName,hsType,hsConSym,hsVarSym,hsString,hsCharacter,hs_EqualsSymbol,hs_NothingStuff
" overwritten from parent (added `hs_TypeDeclaration` to `contains`)
sy match hs_DeclareFunction "^[a-z_(]\S*\(\(\s\|\n\)*,\(\s\|\n\)*[a-z_(]\S*\)*\(\s\|\n\)*\(::\|∷\)"
	\ contains=hs_FunctionName,hs_OpFunctionName,hs_TypeDeclaration,hs_MyDeclFunctionName,hs_MyDeclFunctionComma
sy match hs_MyDeclFunctionName "\v(,(\s|\n)*)@<=[a-z_][^,[:blank:]]*((.|\n)*(::|∷))@=" contained
sy match hs_MyDeclFunctionComma "," contained
" overwritten from parent (added `hs_TypeDeclaration` to `contains`)
sy match hsFFI excludenl "\<foreign\>\(.\&[^\"]\)*\"\(.\)*\"\(\s\|\n\)*\(.\)*\(::\|∷\)"
	\ keepend
	\ contains=hsFFIForeign,hsFFIImportExport,hsFFICallConvention,hsFFISafety,hsFFIString,hs_OpFunctionName,hs_hlFunctionName,hs_TypeDeclaration
" copy-pasted from parent just to make it be applied after root function hl
sy match hsImport "\<import\>\s\+\(qualified\s\+\)\?\(\<\(\w\|\.\)*\>\)"
	\ contains=hsModuleName,hsImportLabel
	\ nextgroup=hsImportParams,hsImportIllegal skipwhite

sy match hs_LambdaFuncDeclBackslash "\\\(\\\)\@!"

sy match hs_MyWarn "\V\((..)\|\(\s\|\^\|(\)\@<=!\(\[a-zA-Z0-9_]\)\@=\)"

" TODO FIXME
sy match hs_MyBoolean "\v(\s|^)@<=(True|False)(\s|$)@="

" \[\\/:=|?!@#$%^&*+.<>~-]\{3,}                  3s and more (anything)
" \[/:|?!@#$%^&*+.<>~-]                          1s excluding (=) and (\)
" \[\\/|?!@#$%^&*+.>~]\[\\/:=|?!@#$%^&*+.<>~-]   2s etc
" \[\\/:=|?!@#$%^&*+.<>~-]\[\\/=|?!@#$%^&*+.<~]  2s etc
" =\[\\/:=|?!@#$%^&*+.<~-]                       2s excluding (=>)
" -\[\\/:=|?!@#$%^&*+.<~]                        2s excluding (->) and (--)
" \[\\/:=|?!@#$%^&*+.>~]-                        2s excluding (<-) and (--)
" \[\\/=|?!@#$%^&*+.<>~-]:                       2s excluding (::)
" :\[\\/=|?!@#$%^&*+.<>~-]                       2s excluding (::)
sy match hs_MyOperators "\V\(\s\|\^\)\@<=\(\[\\/:=|?!@#$%^&*+.<>~-]\{3,}\|\[/:|?!@#$%^&*+.<>~-]\|\[\\/|?!@#$%^&*+.>~]\[\\/:=|?!@#$%^&*+.<>~-]\|\[\\/:=|?!@#$%^&*+.<>~-]\[\\/=|?!@#$%^&*+.<~]\|=\[\\/:=|?!@#$%^&*+.<~-]\|-\[\\/:=|?!@#$%^&*+.<~]\|\[\\/:=|?!@#$%^&*+.>~]-\|\[\\/=|?!@#$%^&*+.<>~-]:\|:\[\\/=|?!@#$%^&*+.<>~-]\)\(\s\|\$\)\@="
sy match hs_MyOperatorsUnicode "\v(\s|^)@<=(∀|★|¬|∧|∨|≡|≠|≢|≤|≥|∘|∘\>|∈|∉|∌|∋|⊥|⧺|⤚|⤙|⤛|⤜|⋅|÷)(\s|$)@="

sy match hs_MyImportAsFix "\v(<import>\s+.+\s+)@<=<as>"
sy match hs_MyImportHidingFix "\v(<import>\s+.+\s+)@<=<hiding>"
sy match hs_MyImportKwFix "\v(^<import>(\s+|$)@=|(^<import>\s+)@<=qualified(\s+|$)@=)"

" just overwritten `hsType` match to fix '(' bracket highlight (kinda hack)
sy match hs_MyBracketFix "\<[A-Z]\(\S\&[^,.(]\)*\>"


hi def link hs_MyImportAsFix Include
hi def link hs_MyImportHidingFix Include
hi def link hs_MyImportKwFix Include

hi def link hs_LambdaFuncDeclBackslash Keyword

hi def link hs_TypeDeclaration Keyword
hi def link hs_TypeDeclNext Typedef
hi def link hs_TypeDeclConstraint PreCondit

hi def link hsDelimiter Identifier
hi def link hs_BackQuotesOperator Identifier

hi def link hs_NothingStuff StorageClass
hi def link hs_MyBoolean StorageClass
hi def link hs_MyOperators Identifier
hi def link hs_MyOperatorsUnicode Identifier
hi def link hs_MyWarn WarningMsg

hi def link hs_EqualsSymbol Constant
hi def link hs_MonadExtract Constant

hi def link hs_MyDeclFunctionName Function
hi def link hs_MyDeclFunctionComma Identifier


if exists('g:hs_MyCustomOperators')
	exec 'sy match hs_MyCustomOperators "'. g:hs_MyCustomOperators .'"'
	hi def link hs_MyCustomOperators Identifier
endif


let b:current_syntax = "haskell"
