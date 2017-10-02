" additional commands, functions and other helpers
" Author: Viacheslav Lotsmanov


command! MakeTags !ctags -R .


function! g:IndentText()
	
	let l:view = winsaveview()
	let l:removed = @@
	let l:text = input('Enter text: ')
	let l:indent = substitute(l:text, '.', ' ', 'g')
	let l:cur_line = line("'0")
	let l:cur_col = virtcol("'0")
	let l:lines = len(split(l:removed, '\n'))
	
	for l:i in range(0, l:lines - 1)
		let l:line_n = l:cur_line + l:i
		let l:line_len = len(getline(l:line_n))
		let l:diff = 0
		let l:offset = l:cur_col - 1
		let l:text_shift = ''
		
		if l:line_len < l:cur_col
			let l:diff = l:cur_col - l:line_len - 1
			let l:offset = l:line_len
			let l:text_shift = join(map(range(1, l:diff), '" "'), '')
		endif
		
		let s:tmp = l:text_shift . ((l:i == 0) ? l:text : l:indent)
		exec l:line_n . 's/\v(^[^\0]{'. l:offset .'})@<=/\=s:tmp/'
	endfor
	
	call winrestview(l:view)
	unlet s:tmp
	
endfunction


function! g:GetNSpaces(n)
	let l:result = ''
	for i in range(a:n) | let l:result = l:result . ' ' | endfor
	return l:result
endfunction
