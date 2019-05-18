" background and gruvbox contrast toggle
" Author: Viacheslav Lotsmanov

" something wrong with 'haskell-vim' syntax plugin, this dirty hack fixes it.
" it's just a copy from 'haskell-vim'
" but 'highlight def link' is replaced with 'hi! link'.
fu! s:fix_haskell_syntax()
	hi! link haskellBottom Macro
	if g:colors_name == 'nova'
		hi! link haskellTH Keyword
	el
		hi! link haskellTH Boolean
	en
	hi! link haskellIdentifier Identifier
	hi! link haskellForeignKeywords Structure
	hi! link haskellKeyword Keyword
	hi! link haskellDefault Keyword
	hi! link haskellConditional Conditional
	hi! link haskellNumber Number
	hi! link haskellFloat Float
	if g:colors_name == 'onedark' || g:colors_name == 'gruvbox'
	\|| g:colors_name == 'codeschool'
		hi! link haskellSeparator Comment
		hi! link haskellDelimiter Comment
	el
		hi! link haskellSeparator Delimiter
		hi! link haskellDelimiter Delimiter
	en
	hi! link haskellInfix Keyword
	if g:colors_name == 'OceanicNext'
		hi! link haskellOperators Keyword
		hi! link haskellQuote Keyword
	el
		hi! link haskellOperators Operator
		hi! link haskellQuote Operator
	en
	hi! link haskellShebang Comment
	hi! link haskellLineComment Comment
	hi! link haskellBlockComment Comment
	hi! link haskellPragma SpecialComment
	hi! link haskellLiquid SpecialComment
	hi! link haskellString String
	hi! link haskellChar String
	if g:colors_name == 'OceanicNext'
		hi! link haskellBacktick Keyword
	el
		hi! link haskellBacktick Operator
	en
	hi! link haskellQuasiQuoted String
	hi! link haskellTodo Todo
	hi! link haskellPreProc PreProc
	hi! link haskellAssocType Type
	hi! link haskellQuotedType Type
	hi! link haskellType Type
	hi! link haskellImportKeywords Include
	if get(g:, 'haskell_classic_highlighting', 0)
		hi! link haskellDeclKeyword Keyword
		hi! link HaskellDerive Keyword
		hi! link haskellDecl Keyword
		hi! link haskellWhere Keyword
		hi! link haskellLet Keyword
	el
		hi! link haskellDeclKeyword Structure
		hi! link HaskellDerive Structure
		hi! link haskellDecl Structure
		hi! link haskellWhere Structure
		hi! link haskellLet Structure
	en

	if get(g:, 'haskell_enable_quantification', 0)
		if g:colors_name == 'OceanicNext'
			hi! link haskellForall Keyword
		el
			hi! link haskellForall Operator
		en
	en
	if get(g:, 'haskell_enable_recursivedo', 0)
		hi! link haskellRecursiveDo Keyword
	en
	if get(g:, 'haskell_enable_arrowsyntax', 0)
		hi! link haskellArrowSyntax Keyword
	en
	if get(g:, 'haskell_enable_static_pointers', 0)
		hi! link haskellStatic Keyword
	en
	if get(g:, 'haskell_classic_highlighting', 0)
		if get(g:, 'haskell_enable_pattern_synonyms', 0)
			hi! link haskellPatternKeyword Keyword
		en
		if get(g:, 'haskell_enable_typeroles', 0)
			hi! link haskellTypeRoles Keyword
		en
	el
		if get(g:, 'haskell_enable_pattern_synonyms', 0)
			hi! link haskellPatternKeyword Structure
		en
		if get(g:, 'haskell_enable_typeroles', 0)
			hi! link haskellTypeRoles Structure
		en
	en

	if get(g:, 'haskell_backpack', 0)
		hi! link haskellBackpackStructure Structure
		hi! link haskellBackpackDependency Include
	en
endf

function! g:ColorschemeCustomizations()
	try
		cal s:fix_haskell_syntax()
		if g:colors_name == 'gruvbox'
			hi! link TabLine     Folded
			hi! link TabLineFill Pmenu
			hi! link TabLineSel  airline_a_bold
		en
	catch
		" handling default colorscheme
		if stridx(v:exception, ':E121:') == -1 | echoe v:exception | endif
	endtry
endfunction

function! s:BackgroundToggle()
	if &background == 'dark'
		set background=light
	elseif &background == 'light'
		set background=dark
	endif

	call g:ColorschemeCustomizations()
endfunction

function! s:GruvboxContrastRotate()
	let l:contrast = ''

	if &background == 'dark'

		if g:gruvbox_contrast_dark == 'soft'
			let g:gruvbox_contrast_dark = 'medium'
		elseif g:gruvbox_contrast_dark == 'medium'
			let g:gruvbox_contrast_dark = 'hard'
		elseif g:gruvbox_contrast_dark == 'hard'
			let g:gruvbox_contrast_dark = 'soft'
		endif

		let l:contrast = g:gruvbox_contrast_dark

	elseif &background == 'light'

		if g:gruvbox_contrast_light == 'soft'
			let g:gruvbox_contrast_light = 'medium'
		elseif g:gruvbox_contrast_light == 'medium'
			let g:gruvbox_contrast_light = 'hard'
		elseif g:gruvbox_contrast_light == 'hard'
			let g:gruvbox_contrast_light = 'soft'
		endif

		let l:contrast = g:gruvbox_contrast_light
	endif

	call s:BackgroundToggle()
	call s:BackgroundToggle()

	echo
		\ "Gruvbox " . &background
		\ . " colorscheme contrast set to: "
		\ . l:contrast
endfunction

command! BackgroundToggle      call s:BackgroundToggle()
command! GruvboxContrastRotate call s:GruvboxContrastRotate()

" vim: set noet :
