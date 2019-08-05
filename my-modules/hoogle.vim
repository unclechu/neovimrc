" FuzzyHoogle command built on top of FZF
" Author: Viacheslav Lotsmanov

let s:shortcut_map = {
	\ 'ctrl-x': 'yank',
	\ 'ctrl-i': 'import',
	\ 'ctrl-p': 'padded import',
	\ 'ctrl-y': 'yank import',
	\ 'ctrl-t': 'yank padded import',
	\ }

fu! s:get_color_code(style, groups)
	let l:gui = has('tgc') && &tgc
	let l:fam = l:gui ? 'gui' : 'cterm'
	let l:pat = l:gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
	for l:group in a:groups
		let l:code = synIDattr(synIDtrans(hlID(l:group)), a:style, l:fam)
		if code =~? pat | retu code | en
	endfo
	retu ''
endf

fu! s:csi(color, fg)
	let l:prefix = a:fg ? '38;' : '48;'
	if a:color[0] == '#'
		retu l:prefix.'2;'.
			\ join(map(
			\   [a:color[1:2], a:color[3:4], a:color[5:6]],
			\   'str2nr(v:val, 16)'
			\ ), ';')
	el
		retu l:prefix.'5;'.a:color
	en
endf

fu! s:colorize(fzf_color_name, str)
	let l:fzf_color = g:fzf_colors[a:fzf_color_name]
	let l:color_code = s:get_color_code(l:fzf_color[0], l:fzf_color[1:])
	let l:color = s:csi(l:color_code, 1)
	retu printf("\x1b[%sm%s\x1b[m", l:color, a:str)
endf

let s:header = ':: '.
	\ join(map(
	\   keys(s:shortcut_map),
	\   's:colorize("hl+", toupper(v:val))." ".s:shortcut_map[v:val]'
	\ ), ', ')

let s:import_reg = '^\([A-Z][^ ]*\) \([^ ]\+\) :: .*$'

let s:import_replace =
	\ 'substitute(l:line, '''.s:import_reg.''', ''import \1 (\2)'', '''')'

let s:padded_import_replace =
	\ 'substitute(l:line, '''.s:import_reg.''', '.
	\ '''import           \1 (\2)'', '''')'

let s:paste_cmd_pfx = 'pu='
let s:yank_cmd_pfx = 'let @@.=((@@=="")?"":"\n").'

fu! s:sink(lines)
	if len(a:lines) < 2 | retu | en
	let l:lines = a:lines[1:]
	let l:action_name = get(s:shortcut_map, a:lines[0], '')

	if l:action_name == 'yank'
		let @@ = ''
		let l:action_cmd = s:yank_cmd_pfx.'l:line'
	elsei l:action_name == 'import'
		let l:action_cmd = s:paste_cmd_pfx.s:import_replace
	elsei l:action_name == 'padded import'
		let l:action_cmd = s:paste_cmd_pfx.s:padded_import_replace
	elsei l:action_name == 'yank import'
		let @@ = ''
		let l:action_cmd = s:yank_cmd_pfx.s:import_replace
	elsei l:action_name == 'yank padded import'
		let @@ = ''
		let l:action_cmd = s:yank_cmd_pfx.s:padded_import_replace
	el
		if l:action_name != ''
			th 'Unexpected action name: '.l:action_name
		en
		let l:action_cmd = s:paste_cmd_pfx.'l:line'
	en

	for l:line in l:lines | exe l:action_cmd | endfo
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
		\ '--header='.s:header,
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
