" FuzzyHoogle command built on top of FZF
" Author: Viacheslav Lotsmanov

" not yet implemented
let s:shortcut_map = {
	\ 'ctrl-x': 'let @@=',
	\ }

fu! s:sink(lines)
	if len(a:lines) < 2 | retu | en
	let l:lines = a:lines[1:]
	let l:action = get(s:shortcut_map, a:lines[0], 'put=')

	if l:action =~ 'let @@='
		exe l:action.'""'
		let l:action = 'let @@.=((@@=="")?"":"\n").'
	en

	for l:line in l:lines | exe l:action.' l:line' | endfo
endf

let s:limit = 1000000

fu! s:handler(fullscreen, qargs)
	let l:cmd = 'hoogle --count='.shellescape(s:limit)
		\.' -- '.shellescape(a:qargs).' | '
		\.'while read x; do '
		\.  'printf "%s" "$x" | grep --color=always -iF -- '.shellescape(a:qargs)
		\.  ' || printf "%s\n" "$x"'
		\.';done'

	let l:fzf_opts = [
		\ '--multi', '--tiebreak=index', '--ansi',
		\ '--prompt', 'Hoogle> ', '--expect', join(keys(s:shortcut_map), ','),
		\ ]

	let l:fzf = {
		\ 'source': l:cmd,
		\ 'options': l:fzf_opts,
		\ 'sink*': funcref('s:sink'),
		\ }

	retu fzf#run(fzf#wrap('Hoogle', l:fzf, a:fullscreen))
endf

com! -bang -nargs=+ FuzzyHoogle cal s:handler(<bang>0, <q-args>)

" vim: set noet :
