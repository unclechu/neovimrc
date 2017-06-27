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
sy region hs_Function start="^xxx BLOCKED xxx["'a-zA-Z_([{]\(\(.\&[^=]\)\|\(\n\s\)\)*=" end="\(\s\|\n\|\w\|[([]\)"
	\ contains=hs_OpFunctionName,hs_InfixOpFunctionName,hs_My_InfixFunctionName,hs_FunctionName,hsType,hsConSym,hsVarSym,hsString,hsCharacter,hs_EqualsSymbol,hs_NothingStuff
" overwritten from parent (added `hs_TypeDeclaration` to `contains`)
sy match hs_DeclareFunction "^[a-z_(]\S*\(\s\|\n\)*\(::\|∷\)"
	\ contains=hs_FunctionName,hs_OpFunctionName,hs_TypeDeclaration
" overwritten from parent (added `hs_TypeDeclaration` to `contains`)
sy match hsFFI excludenl "\<foreign\>\(.\&[^\"]\)*\"\(.\)*\"\(\s\|\n\)*\(.\)*\(::\|∷\)"
	\ keepend
	\ contains=hsFFIForeign,hsFFIImportExport,hsFFICallConvention,hsFFISafety,hsFFIString,hs_OpFunctionName,hs_hlFunctionName,hs_TypeDeclaration
" copy-pasted from parent just to make it be applied after root function hl
sy match hsImport "\<import\>\s\+\(qualified\s\+\)\?\(\<\(\w\|\.\)*\>\)"
	\ contains=hsModuleName,hsImportLabel
	\ nextgroup=hsImportParams,hsImportIllegal skipwhite

sy match hs_LambdaFuncDeclBackslash "\\"

sy match hs_MyBoolean "\v<(True|False)>"


sy match hs_MyOperators "\v(\s|^)@<=(:|!|!!|∀|★|¬|∧|∨|≡|≠|≢|≤|≥|∘|∘>|∈|∉|∌|∋|⊥|⧺|⤚|⤙|⤛|⤜|⋅|÷|-)(\s|$)@="
sy match hs_MyOperators2 "\v(\s|^)@<=([|&]{2}|[/=]{2}|\<?[|&*$]+\>?|[%+*-.=$^][~.=%$*^][~=-^]?)(\s|$)@="
sy match hs_MyOperators3 "\V\(\s\|\^\)\@<=\(?\||?|\|.&.\|&&&\|***\|+\|++\|:>\|:<|>\|.:\|:.\)\(\s\|\$\)\@="
sy match hs_MyOperators4 "\V\(\s\|\^\)\@<=\(.\|.>\|.|.\|<=\?\|>=\?\|>>=\?\|=\?<<\|>=>\|<=<\)\(\s\|\$\)\@="
sy match hs_MyOperators5Lens "\V\(\s\|\^\)\@<=\(&~\|?=\)\(\s\|\$\)\@="
sy match hs_MyWarn "\V(..)"

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
hi def link hs_MyOperators2 Identifier
hi def link hs_MyOperators3 Identifier
hi def link hs_MyOperators4 Identifier
hi def link hs_MyOperators5Lens Identifier
hi def link hs_MyWarn WarningMsg

hi def link hs_EqualsSymbol Constant
hi def link hs_MonadExtract Constant


if exists('g:hs_MyCustomOperators')
	exec 'sy match hs_MyCustomOperators "'. g:hs_MyCustomOperators .'"'
	hi def link hs_MyCustomOperators Identifier
endif


let b:current_syntax = "haskell"
