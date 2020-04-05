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


" Mark line(s) you want to replace with (other lines will be only indented):
"   1.  '^' - first line of the visually selected block
"   2.  '$' - last line of the visually selected block
"   3.  '1' - one line below the first line
"   4.  '2' - two lines below the first line
"   5.  'N' - N lines below the first line
"   6. '-1' - one line above the last line
"   7. '-2' - two lines above the last line
"   8. '-N' - N lines above the last line
" where N is infinitely increasing integer number.
"
" The syntax is line(s) (see above) separated with commas
" and new text after space.
"
" An example of a Haskell data-type:
"
"   newtype Foo a
"         = Foo
"         { unFoo :: a
"         }
"
" If you select 'newtype' in Visual Mode then press ^V in order to switch to
" Visual Block Mode and then press '3j' sequentially so you would get a block
" selected (including '=', '{' and '}' symbols). Then you may call this
" function. Provide this input value: '^ data' and the result will be:
"
"   data Foo a
"      = Foo
"      { unFoo :: a
"      }
"
" If you select now 'data' and using Visual Block Mode select the whole block
" down and run this function with '^ newtype' input then you get the original
" 'newtype'.
"
fu! g:IndentTextBlock()
	" FIXME mode() is only correct for an <expr> map
	" if mode() != '' | th 'Not the Visual Block Mode: '.mode() | en
	
	let view = winsaveview()
	
	" Names of the variables explanation: 'x' and 'y' + (f)rom and (t)o.
	" 'xf' and 'xt' are starting from 0 because it's how we use it below.
	let [from, to] = [getpos("'<"), getpos("'>")]
	let [yf, yt] = sort([from[1],           to[1]        ], 'n')
	let [xf, xt] = sort([from[2]+from[3]-1, to[2]+to[3]-1], 'n')
	
	" This way of getting selection rectangle coordinates
	" works correctly only with <expr> map.
	" let [yf, yt] = sort([line('v'),      line('.')     ], 'n')
	" let [xf, xt] = sort([virtcol('v')-1, virtcol('.')-1], 'n')
	
	let text = input('Replace text in line: ', '^ ')
	if text == '' | retu | en " Cancelled
	let text_split = split(text, ' ')
	if text_split[0] == '' | th 'Incorrect lines' | en
	let line_numbers = split(text_split[0], ',')
	let text = text[len(text_split[0])+1:]
	unl text_split
	
	" Expand specified relative lines into absolute line numbers.
	for idx in range(0, len(line_numbers) - 1)
		if line_numbers[idx] == '^' | let line_numbers[idx] = yf
		elsei line_numbers[idx] == '$' | let line_numbers[idx] = yt
		elsei line_numbers[idx] =~ '^-\?[0-9]\+$'
			let relative_line_nr = str2nr(line_numbers[idx])
			
			let absolute_line_nr =
				\ ((line_numbers[idx][0] == '-') ? yt : yf) + relative_line_nr
			
			if absolute_line_nr < yf || absolute_line_nr > yt
				th 'Line '.line_numbers[idx].' is out of selection range'
					\.' (it resolved to '.absolute_line_nr.' absolute value'
					\.' whilst selection range is in between '.yf.' and '.yt
					\.' line inclusive)'
			en
			
			let line_numbers[idx] = absolute_line_nr
		el | th 'Unexpected line value: "'.line.'"' | en
	endfo
	
	" Handle each line of the selected block.
	for line_nr in range(yf, yt)
		let line = getline(line_nr)
		
		" Handling tabs is a tricky task, I don't need it at the moment,
		" so just fail for such an attempt.
		if line[0:xt] =~ '\t'
			th 'Line '.line_nr.' contains tabs, this function is not intended'
				\.' to be used with code indented with tabs'
		en
		
		let line_before = line[0:xf-1] " Preceding value of selected block
		
		" Handle empty line or shorter than selection block start position
		if len(line_before) < xf
			" Just fill the gap with spaces
			let line_before .= GetNSpaces(xf - len(line_before))
		en
		
		let line_selection = line[xf:xt] " Value of a selected block area
		let selection_block_width = (xt - xf) + 1
		let width_diff = len(text) - selection_block_width
		
		" This line is in the list of line numbers to replace with a new value
		if index(line_numbers, line_nr) != -1
			let line_selection = text
		
		" New value is longer than previous one
		elsei width_diff > 0
			let line_selection = GetNSpaces(width_diff) . line_selection
		
		" New value is shorter than previous one
		elsei width_diff < 0
			let indent = matchstr(line_selection, '^ \+')
			
			let line_selection =
				\ indent[-width_diff:] . line_selection[len(indent):]
		en
		
		let line_after = line[xt+1:] " Succeeding value of a selected block
		cal setline(line_nr, line_before.line_selection.line_after)
	endfo
	
	cal winrestview(view)
endf


" Gets a number and returns a strings of repeated space symbol n-times
" where n is that number.
fu! g:GetNSpaces(n)
	let l:result = ''
	for i in range(a:n) | let l:result .= ' ' | endfo
	retu l:result
endf


" Returns a string with selected text in visual mode.
" WARNING! It doesn't work with visual-block selection.
fu! g:GetSelectedText()
	let [l:line_a, l:col_a] = getpos("'<")[1:2]
	let [l:line_b, l:col_b] = getpos("'>")[1:2]
	let l:lines = getline(l:line_a, l:line_b)
	if len(l:lines) == 0 | retu '' | el
		let l:lines[-1] = l:lines[-1][: l:col_b - 1  ]
		let l:lines[ 0] = l:lines[ 0][  l:col_a - 1 :]
		retu join(l:lines, "\n")
	en
endf
