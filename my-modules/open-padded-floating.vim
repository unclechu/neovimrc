" Author: Viacheslav Lotsmanov

let s:intreg = '\v^\d+$'
let s:percentreg = '\v^(\d+)(\%$)@='

fu! g:OpenPaddedFloating(buffer, ...)
	let l:buf = a:buffer =~ s:intreg ? +a:buffer : bufnr(a:buffer)
	let l:pad_x = 7 | let l:pad_y = 7
	let l:err = 'OpenPaddedFloating: invalid arguments: ' . string(a:000)
	
	if len(a:000) == 1
		if a:000[0] =~ s:intreg
			let l:pad_x = +a:000[0]
			let l:pad_y = l:pad_x
		elsei a:000[0] =~ s:percentreg
			let l:percent = 100 - matchstr(a:000[0], s:percentreg)
			let l:pad_x = &co    - (&co    * l:percent / 100)
			let l:pad_y = &lines - (&lines * l:percent / 100)
			let l:pad_x = l:pad_x / 2
			let l:pad_y = l:pad_y / 2
		el | th l:err | en
	elsei len(a:000) == 2
		if (a:000[0] =~ s:intreg || a:000[0] =~ s:percentreg)
		\ && (a:000[1] =~ s:intreg || a:000[1] =~ s:percentreg)
			if a:000[0] =~ s:intreg
				let l:pad_x = +a:000[0]
			elsei a:000[0] =~ s:percentreg
				let l:percent_x = 100 - matchstr(a:000[0], s:percentreg)
				let l:pad_x = &co - (&co * l:percent_x / 100)
				let l:pad_x = l:pad_x / 2
			en
			if a:000[1] =~ s:intreg
				let l:pad_y = +a:000[1]
			elsei a:000[1] =~ s:percentreg
				let l:percent_y = 100 - matchstr(a:000[1], s:percentreg)
				let l:pad_y = &lines - (&lines * l:percent_y / 100)
				let l:pad_y = l:pad_y / 2
			en
		el | th l:err | en
	elsei len(a:000) != 0 | th l:err | en
	
	retu nvim_open_win(l:buf, 1, {
		\ 'relative': 'editor',
		\ 'width':    &co    - (l:pad_x * 2),
		\ 'height':   &lines - (l:pad_y * 2),
		\ 'col':      l:pad_x,
		\ 'row':      l:pad_y,
		\})
endf

com! -nargs=* PaddedFloating    cal OpenPaddedFloating(0, <f-args>)
com! -nargs=+ PaddedFloatingBuf cal OpenPaddedFloating(   <f-args>)

" vim: set noet :
