" additional functions and variables
" Author: Viacheslav Lotsmanov


" Some date masks for `strftime` function
let g:rfc822 = '%a, %d %b %Y %H:%M:%S %z'
let g:orgdf  = '<%Y-%m-%d %a>'
let g:orgdfi = '<%Y-%m-%d %a>--<%Y-%m-%d %a>'
let g:orgtf  = '<%Y-%m-%d %a %H:%M>'
let g:orgtfi = '<%Y-%m-%d %a %H:%M-%H:%M>'


" Helps with code aligning when you insert some text in middle of the line and
" next lines are aligned depending on left part which is going to become longer
" after your changes.
"
" You can select few lines in Visual-Block Mode to replace or to insert some
" text in front of selected column and this helper automatically prepend all
" lines next to current one with proper amount of spaces.
fu! g:IndentText()
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
		en
		
		let s:tmp = l:text_shift . ((l:i == 0) ? l:text : l:indent)
		exe l:line_n.'s/\v(^[^\0]{'.l:offset.'})@<=/\=s:tmp/'
	endfo
	
	cal winrestview(l:view)
	unl s:tmp
endf


" Gets a number and returns a strings of repeated space symbol n-times
" where n is that number.
fu! g:GetNSpaces(n)
	let l:result = ''
	for i in range(a:n) | let l:result .= ' ' | endfo
	retu l:result
endf
