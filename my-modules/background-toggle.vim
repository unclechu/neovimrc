" background and gruvbox contrast toggle
" Author: Viacheslav Lotsmanov

function! g:GruvboxCustomizations()
	try
		if g:colors_name == 'gruvbox' |
			hi! link haskellSeparator GruvboxGray
		endif
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

	call g:GruvboxCustomizations()
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
