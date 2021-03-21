" GitGrep command built on top of FZF
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

let s:git_grep_shortcut_map = {
	\ 'ctrl-t': 'tabe',
	\ 'ctrl-x': 'sp',
	\ 'ctrl-v': 'vs',
	\ }

fu! s:git_grep_sink(lines)
	if len(a:lines) < 2 | retu | en

	if len(a:lines) > 2
		th 'GitGrep sink*: Unexpectedly given more than 2 args: '.
			\ string(a:lines)
	en

	let l:action = get(s:git_grep_shortcut_map, a:lines[0], 'e')
	let l:reg = '^\(.\{-1,}\):\([0-9]\+\):.\+$'

	if a:lines[1] !~ l:reg
		th 'GitGrep sink*: argument of a match is incorrect: '.a:lines[1]
	en

	let l:file = substitute(a:lines[1], l:reg, '\1', '')
	let l:line = substitute(a:lines[1], l:reg, '\2', '')
	exe l:action.' '.l:file | exe l:line
endf

let s:cached_nproc = 0

" TODO maybe there's a way to obtain column of a match?
"      `-n` shows line numbers but i couldn't find how to show column numbers,
"      so i could jump not only to specific line but also to a specific column.
fu! s:git_grep(fullscreen, qargs)
	if s:cached_nproc == 0 | let s:cached_nproc += system('nproc --all') | en
	let l:grep_opts = '--threads '.s:cached_nproc.' --color -nI '
	let l:tail = a:qargs

	" first grep options go
	wh 1
		if len(l:tail) == 0 | th 'GitGrep: not enough arguments' | en
		if l:tail[0] == ' ' | let l:tail = l:tail[1:] | brea | en
		if l:tail[0:1] == '\ '
			let l:grep_opts .= ' ' | let l:tail = l:tail[2:] | con
		en
		let l:grep_opts .= l:tail[0] | let l:tail = l:tail[1:]
	endw

	if len(l:tail) == 0 | th 'GitGrep: not enough arguments' | en
	let l:search_query = ''

	" search query goes
	wh 1
		if len(l:tail) == 0 | brea | en
		if l:tail[0:1] == ' |'
			if l:tail =~ '^ |\s*$' | th 'GitGrep: piped to nothing' | en
			let l:tail = l:tail[2:]
			brea
		en
		if l:tail[0:2] == ' \|'
			let l:search_query .= ' |' | let l:tail = l:tail[3:] | con
		en
		let l:search_query .= l:tail[0] | let l:tail = l:tail[1:]
	endw

	let l:cmd = 'git grep '.l:grep_opts.' -- '.shellescape(l:search_query)

	" in case it's piped, taking rest as a raw shell stuff
	if len(l:tail) > 0 | let l:cmd .= ' | '.l:tail | en

	let l:fzf_opts = [
		\ '--ansi', '--prompt', 'GitGrep> ',
		\ '--expect', join(keys(s:git_grep_shortcut_map), ','),
		\ ]

	let l:fzf = {
		\ 'source': l:cmd,
		\ 'options': l:fzf_opts,
		\ 'sink*': funcref('s:git_grep_sink'),
		\ }

	retu fzf#run(fzf#wrap('GitGrep', l:fzf, a:fullscreen))
endf

" Bang gives you fullscreen mode.
"
" Few examples of usage (you have to escape spaces and tabs!):
"   GitGrep -F some string
"   GitGrep! -F some string
"
" You also can pipe it with other shell commands
" (after first pipe `|` symbol you have to escape spaces, like it was <f-args>):
"   GitGrep -F some string | grep -v exclude | grep -v \.md
"
" If you need pipe symbol `|` as part of your search string then escape it:
"   GitGrep -F some \| string
" It will be interpreted as:
"   git grep ... -F -- 'some | string'
"
" If pipe symbol goes first in your search query (no spaces at start)
" you musn't escape it:
"   GitGrep -F | some string
" It will be interpreted as:
"   git grep ... -F -- '| some string'
" But this (space at the start):
"   GitGrep -F   | grep -v foo
" It will be interpreted as:
"   git grep ... -F -- ' ' | grep -v foo
" Escape `|` to avoid that.
" Keep in mind that `|` eats space before it, so this:
"   GitGrep -F  | grep -v foo
" It will be interpreted as (empty search query, could be useful to navigate
" over all lines of all files which are in git-index):
"   git grep ... -F -- '' | grep -v foo
"
" Pipe symbol must be preceded with space,
" otherwise it will be interpreted as regular text, like in this case:
"   GitGrep -F some|string
" In this case it's piped:
"   GitGrep -F some |grep -v smth
"
" If you need space at the end before piping just add another space:
"   GitGrep -F some  |grep -v smth
" It will be interpreted as:
"   git grep ... -F -- 'some ' |grep -v smth
"
" If you need space at the beginning, just after grep options, just add some:
"   GitGrep -F  some  |grep -v smth
" It will be interpreted as:
"   git grep ... -F -- ' some ' |grep -v smth
"
" If you need more than one grep option (separated by spaces) escape spaces:
"   GitGrep -F\ -i  some  |grep -v smth
" It will be interpreted as:
"   git grep ... -F -i -- ' some ' |grep -v smth
"
com! -bang -nargs=+ GitGrep cal s:git_grep(<bang>0, <q-args>)

" vim: set noet :
