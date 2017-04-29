" Author: Viacheslav Lotsmanov
" TODO refactoring

function! s:PrettifyJSON(str, indent)

	let l:prepared =
		\ substitute(
		\ substitute(
		\ a:str, '\r\n', '\r', 'g'),
		\ '\n', '\r', 'g'
	\ )

	let l:result = system("echo ". shellescape(l:prepared) ." | python3 -c "
		\ ."'import sys,json;"
		\ ."x=\"\".join([x for x in sys.stdin]);"
		\ ."print(json.dumps(json.loads(x),indent=\"'"
		\ . shellescape(a:indent) ."'\"))'"
	\ )

	return [(v:shell_error ? 1 : 0), l:result]
endfunction

function! s:PrettifyJSONRange(indent)

	if line('.') < a:lastline
		return
	endif

	let l:indent = ''

	if a:indent =~ '^\d\+$'
		for i in range(1, a:indent)
			let l:indent = l:indent . ' '
		endfor
	else
		let l:indent = a:indent
	endif

	let l:prettify_result = s:PrettifyJSON(
		\ join(getline(a:firstline, a:lastline), "\n"),
		\ l:indent
	\ )

	if l:prettify_result[0] != 0

		let l:err =
			\ substitute(
			\ substitute(
			\ substitute(l:prettify_result[1], '\r\n', '\n', 'g'),
			\ '\r', '\n', 'g'),
			\ '[\n]\+$', '', 'g')

		echoerr "Prettify JSON error:"

		for l:line in split(l:err, "\n")
			echoerr l:line
		endfor

		return
	endif

	let l:pretty =
		\ substitute(
		\ substitute(
		\ substitute(l:prettify_result[1], '\r\n', '\r', 'g'),
		\ '\n', '\r', 'g'),
		\ '[\r]\+$', '', 'g')

	let l:linetoremove = (a:firstline+1)

	if a:lastline >= l:linetoremove
		exec ''. l:linetoremove .','. a:lastline .'d'
	endif

	call cursor(a:firstline, 0)
	exec a:firstline .'s/^.*$/\=l:pretty/g'
endfunction

command! -range -nargs=1 PrettifyJSON
	\ <line1>,<line2>call s:PrettifyJSONRange(<f-args>)
