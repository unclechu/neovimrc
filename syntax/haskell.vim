"my own additional customizations for haskell syntax highlighting
"Author: Viacheslav Lotsmanov


if exists("b:current_syntax")
	finish
endif

" parent
let s:path = expand('<sfile>:p:h:h') . "/haskell-vim-proto/vim/syntax/haskell.vim"
exec "source " . s:path
unlet s:path


sy match hs_TypeDeclaration "\(\s\|^\)::\(\s\|$\)"
sy match hs_TypeDeclNext "\(\s\|^\)->\(\s\|$\)"
sy match hs_TypeDeclConstraint "\(\s\|^\)=>\(\s\|$\)"
sy match hs_EqualsSymbol "\(\s\|^\)=\(\s\|$\)"
sy match hs_MonadExtract "\s<-\s"

sy match hs_NothingStuff "\(()\|\<undefined\>\)"
sy match hs_BackQuotesOperator "`[a-zA-Z0-9_']\+`"

" overwritten from parent
" (added `hs_EqualsSymbol` and `hs_NothingStuff` to `contains`)
sy region hs_Function start="^["'a-zA-Z_([{]\(\(.\&[^=]\)\|\(\n\s\)\)*=" end="\(\s\|\n\|\w\|[([]\)"
	\ contains=hs_OpFunctionName,hs_InfixOpFunctionName,hs_InfixFunctionName,hs_FunctionName,hsType,hsConSym,hsVarSym,hsString,hsCharacter,hs_EqualsSymbol,hs_NothingStuff
" overwritten from parent (added `hs_TypeDeclaration` to `contains`)
sy match hs_DeclareFunction "^[a-z_(]\S*\(\s\|\n\)*::"
	\ contains=hs_FunctionName,hs_OpFunctionName,hs_TypeDeclaration

sy match hs_LambdaFuncDeclBackslash "\\"

sy match hs_MyBoolean "\<\(True\|False\)\>"


hi def link hs_LambdaFuncDeclBackslash Keyword

hi def link hs_TypeDeclaration Keyword
hi def link hs_TypeDeclNext Typedef
hi def link hs_TypeDeclConstraint PreCondit

hi def link hsDelimiter Identifier
hi def link hs_BackQuotesOperator Identifier

hi def link hs_NothingStuff StorageClass
hi def link hs_MyBoolean StorageClass

hi def link hs_EqualsSymbol Constant
hi def link hs_MonadExtract Constant


let b:current_syntax = "haskell"
