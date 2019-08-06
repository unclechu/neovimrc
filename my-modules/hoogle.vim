" FuzzyHoogle command built on top of FZF
" Author: Viacheslav Lotsmanov

let s:shortcut_map = {
	\ 'ctrl-x': 'yank',
	\ 'ctrl-i': 'import',
	\ 'ctrl-y': 'yank import',
	\ 'ctrl-p': 'padded import',
	\ 'ctrl-k': 'yank padded import',
	\ 'ctrl-f': 'qualified import',
	\ 'ctrl-e': 'yank qualified import',
	\ }

let s:shortcuts_order = [
	\ 'ctrl-x',
	\ 'ctrl-i',
	\ 'ctrl-y',
	\ 'ctrl-p',
	\ 'ctrl-k',
	\ 'ctrl-f',
	\ 'ctrl-e',
	\ ]

if sort(keys(s:shortcut_map)) != sort(copy(s:shortcuts_order))
	th 'Shortcuts set from shortcut map is not equal to '.
		\ 'shortcuts set from ordering list!'
en

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
	\   copy(s:shortcuts_order),
	\   's:colorize("hl+", toupper(v:val))." ".s:shortcut_map[v:val]'
	\ ), ', ')

let s:import_reg = '^\(\([A-Z]\)[^ ]*\) \([^ ]\+\) :: .*$'
let s:import_module_reg = '^module \(\([A-Z]\)[^ ]*\)$'
let s:import_package_reg = '^package \([^ ]\+\)$'

let s:import_class_reg =
	\ '^\(\([A-Z]\)[^ ]*\) class \(.* => \)\?\([^ ]\+\).*$'

let s:import_data_reg =
	\ '^\(\([A-Z]\)[^ ]*\) \(data\\|newtype\) \([^ ]\+\).*$'

let s:import_type_reg =
	\ '^\(\([A-Z]\)[^ ]*\) type\( family\)\? \([^ ]\+\).*$'

" same amount of spaces as amount of chars in 'qualified' word
let s:pad = '         '

let s:import_replace =
	\ 'substitute(substitute(substitute(substitute(substitute('.
	\ 'substitute(l:line, '.
	\ ''''.s:import_reg.''', ''import \1 (\3)'', ''''), '.
	\ ''''.s:import_module_reg.''', ''import \1'', ''''), '.
	\ ''''.s:import_package_reg.''', ''import \"\1\" …'', ''''), '.
	\ ''''.s:import_class_reg.''', ''import \1 (\4 (..))'', ''''), '.
	\ ''''.s:import_data_reg.''', ''import \1 (\4 (..))'', ''''), '.
	\ ''''.s:import_type_reg.''', ''import \1 (\4)'', '''')'

let s:padded_import_replace =
	\ 'substitute(substitute(substitute(substitute(substitute('.
	\ 'substitute(l:line, '.
	\ ''''.s:import_reg.''', ''import '.s:pad.' \1 (\3)'', ''''), '.
	\ ''''.s:import_module_reg.''', ''import '.s:pad.' \1'', ''''), '.
	\ ''''.s:import_package_reg.''', ''import '.s:pad.' \"\1\" …'', ''''), '.
	\ ''''.s:import_class_reg.''', ''import '.s:pad.' \1 (\4 (..))'', ''''), '.
	\ ''''.s:import_data_reg.''', ''import '.s:pad.' \1 (\4 (..))'', ''''), '.
	\ ''''.s:import_type_reg.''', ''import '.s:pad.' \1 (\4)'', '''')'

let s:qualified_import_replace =
	\ 'substitute(substitute(substitute(substitute(substitute('.
	\ 'substitute(l:line, '.
	\ ''''.s:import_reg.''', ''\=s:qualify(0)'', ''''), '.
	\ ''''.s:import_module_reg.''', ''\=s:qualify(1)'', ''''), '.
	\ ''''.s:import_package_reg.''', ''\=s:qualify(4)'', ''''), '.
	\ ''''.s:import_class_reg.''', ''\=s:qualify(2)'', ''''), '.
	\ ''''.s:import_data_reg.''', ''\=s:qualify(2)'', ''''), '.
	\ ''''.s:import_type_reg.''', ''\=s:qualify(3)'', '''')'

fu! s:qualify(type)
	let l:words = split(submatch(1), '\.')
	let l:letter = submatch(2)

	if len(l:words) > 1
		let l:letter = (len(l:words[-1]) < 3) ? l:words[-1] : l:words[-1][0]
	en

	if a:type == 0 " regular import
		retu 'import qualified '.submatch(1).' as '.l:letter.
			\ ' ('.submatch(3).')'
	elsei a:type == 1 " import of a module
		retu 'import qualified '.submatch(1).' as '.l:letter
	elsei a:type == 2 " import of a class or a data-type
		retu 'import qualified '.submatch(1).' as '.l:letter.
			\ ' ('.submatch(4).' (..))'
	elsei a:type == 3 " import of a type (or type family)
		retu 'import qualified '.submatch(1).' as '.l:letter.
			\ ' ('.submatch(4).')'
	elsei a:type == 4 " import from package (see PackageImports extension)
		retu 'import qualified "'.submatch(1).'" … as …'
	el | th 'Unexpected type: '.a:type | en
endf

let s:paste_cmd_pfx = 'pu='
let s:yank_cmd_pfx = 'let @@.='
let s:yank_cmd_sfx = ".'\n'"

fu! s:sink(lines)
	if len(a:lines) < 2 | retu | en
	let l:lines = a:lines[1:]
	let l:action_name = get(s:shortcut_map, a:lines[0], '')

	if l:action_name == 'yank'
		let @@ = ''
		let l:action_cmd = s:yank_cmd_pfx.'l:line'.s:yank_cmd_sfx
	elsei l:action_name == 'import'
		let l:action_cmd = s:paste_cmd_pfx.s:import_replace
	elsei l:action_name == 'padded import'
		let l:action_cmd = s:paste_cmd_pfx.s:padded_import_replace
	elsei l:action_name == 'yank import'
		let @@ = ''
		let l:action_cmd = s:yank_cmd_pfx.s:import_replace.s:yank_cmd_sfx
	elsei l:action_name == 'yank padded import'
		let @@ = ''
		let l:action_cmd = s:yank_cmd_pfx.s:padded_import_replace.s:yank_cmd_sfx
	elsei l:action_name == 'qualified import'
		let l:action_cmd = s:paste_cmd_pfx.s:qualified_import_replace
	elsei l:action_name == 'yank qualified import'
		let @@ = ''
		let l:action_cmd =
			\ s:yank_cmd_pfx.s:qualified_import_replace.s:yank_cmd_sfx
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
		\ '--prompt', 'Hoogle> ', '--expect', join(s:shortcuts_order, ','),
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
