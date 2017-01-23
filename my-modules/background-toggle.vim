" background and gruvbox contrast toggle
" Author: Viacheslav Lotsmanov

function! s:BackgroundToggle()
	if &background == 'dark'
		set background=light
	elseif &background == 'light'
		set background=dark
	endif
endfunction

function! s:GruvboxContrastRotate()
	let s:contrast = ''
	if &background == 'dark'
		if g:gruvbox_contrast_dark == 'soft'
			let g:gruvbox_contrast_dark = 'medium'
		elseif g:gruvbox_contrast_dark == 'medium'
			let g:gruvbox_contrast_dark = 'hard'
		elseif g:gruvbox_contrast_dark == 'hard'
			let g:gruvbox_contrast_dark = 'soft'
		endif
		let s:contrast = g:gruvbox_contrast_dark
	elseif &background == 'light'
		if g:gruvbox_contrast_light == 'soft'
			let g:gruvbox_contrast_light = 'medium'
		elseif g:gruvbox_contrast_light == 'medium'
			let g:gruvbox_contrast_light = 'hard'
		elseif g:gruvbox_contrast_light == 'hard'
			let g:gruvbox_contrast_light = 'soft'
		endif
		let s:contrast = g:gruvbox_contrast_light
	endif
	call s:BackgroundToggle()
	call s:BackgroundToggle()
	echo
		\ "Gruvbox " . &background
		\ . " colorscheme contrast set to: "
		\ . s:contrast
endfunction

command! BackgroundToggle      call s:BackgroundToggle()
command! GruvboxContrastRotate call s:GruvboxContrastRotate()

" vim: set noet :
