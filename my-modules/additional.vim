" additional commands, functions and other helpers
" Author: Viacheslav Lotsmanov


command! MakeTags !ctags -R .


" useful for multi-line visual block editing with decorative indentation.
" inserts N (length of input text) spaces and copies original text to default
" clipboard register.
function! g:IndentText(text)
	let @" = a:text
	return substitute(a:text, '.', ' ', 'g')
endfunction
