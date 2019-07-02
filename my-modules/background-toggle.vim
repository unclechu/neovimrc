" background and gruvbox contrast toggle
" Author: Viacheslav Lotsmanov

fu! s:BackgroundToggle()
	if &bg == 'dark'
		se bg=light
	elsei &bg == 'light'
		se bg=dark
	en

	cal g:ColorschemeCustomizations()
endf

fu! s:GruvboxContrastRotate()
	let l:contrast = ''

	if &bg == 'dark'

		if g:gruvbox_contrast_dark == 'soft'
			let g:gruvbox_contrast_dark = 'medium'
		elsei g:gruvbox_contrast_dark == 'medium'
			let g:gruvbox_contrast_dark = 'hard'
		elsei g:gruvbox_contrast_dark == 'hard'
			let g:gruvbox_contrast_dark = 'soft'
		en

		let l:contrast = g:gruvbox_contrast_dark

	elsei &bg == 'light'

		if g:gruvbox_contrast_light == 'soft'
			let g:gruvbox_contrast_light = 'medium'
		elsei g:gruvbox_contrast_light == 'medium'
			let g:gruvbox_contrast_light = 'hard'
		elsei g:gruvbox_contrast_light == 'hard'
			let g:gruvbox_contrast_light = 'soft'
		en

		let l:contrast = g:gruvbox_contrast_light
	en

	cal s:BackgroundToggle()
	cal s:BackgroundToggle()

	ec 'Gruvbox '.&bg.' colorscheme contrast set to: '.l:contrast
endf

com! BackgroundToggle      cal s:BackgroundToggle()
com! GruvboxContrastRotate cal s:GruvboxContrastRotate()

" vim: set noet :
