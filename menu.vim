" actions menu declaration
" Author: Viacheslav Lotsmanov


let s:menus = {}
let s:menus.ls = {'description': 'LiveScript/LS'}
let s:menus.ls.command_candidates = [
	\ ['Compile selected chunk to JS using LSC', "'<,'>!lsc -cbps | sed 1d"],
	\ ['Get AST from selected chunk using LSC', "'<,'>!lsc -cbpsa"],
	\]
let s:menus.cs = {'description': 'CoffeeScript/CS'}
let s:menus.cs.command_candidates = [
	\ ['Compile selected chunk to JS', "'<,'>!coffee -bsp"],
	\ ['Get AST from selected chunk', "'<,'>!coffee -bst"],
	\]
let s:menus.haskell = {'description': 'Haskell'}
let s:menus.haskell.command_candidates = [
	\ ['Hoogle (command)',
	\    "exec \"let x = input('Hoogle ') | exec 'Hoogle ' . x\""],
	\]
let s:menus.denite = {'description': 'Denite call presets'}
let s:menus.denite.command_candidates = [
	\ ['MRU', 'Denite file_mru'],
	\ ['Buffers', 'Denite buffer'],
	\ ['MRU + Buffers (insert)', 'Denite file_mru buffer'],
	\ ['Grep by Git files', 'Denite grep/git:.'],
	\ ['Grep by Git files (case insensitive)', 'Denite grep/git:.:-i'],
	\ ['Grep by Git files (bare string)', 'Denite grep/git:.:-F'],
	\ ['Grep by Git files (bare string and case insensitive)', 'Denite grep/git:.:-iF'],
	\ ['Git log', 'Denite gitlog'],
	\]
let s:menus.view = {'description': 'View'}
let s:menus.view.command_candidates = [
	\ ['Top field',
	\    "exec \"let x = input('Field height: ') | winc n | winc K | se ro"
	\      . "| se noma | se wfh | 9999winc - | let &wh = x | winc p\""],
	\ ['Left field',
	\    "exec \"let x = input('Field width: ') | winc n | winc H | se ro"
	\      . "| se noma | se wfw | 9999winc < | let &wiw = x | winc p\""],
	\]
let s:menus.ctrlspace = {'description': 'CtrlSpace'}
let s:menus.ctrlspace.command_candidates = [
	\ ['Save workspace',
	\    "let x = input('Workspace name: ') | echo ' '"
	\      . "| exec 'CtrlSpaceSaveWorkspace ' . x"],
	\]
let s:menus.quickhl = {'description': 'Quickhl'}
let s:menus.quickhl.command_candidates = [
	\ ['Manual add pattern',
	\    "let x = input('Pattern: ') | echo ' '"
	\      . "| exec 'QuickhlManualAdd ' . x"],
	\ ['Manual remove pattern', 'QuickhlManualDelete'],
	\ ['Manual list', 'QuickhlManualList'],
	\ ['Manual lock (temporarily hide highlights)', 'QuickhlManualLock'],
	\ ['Manual unlock (restore hidden highlights)', 'QuickhlManualUnlock'],
	\]
let s:menus.dein = {'description': 'Dein'}
let s:menus.dein.command_candidates = [
	\ ['Update plugins', 'call dein#update()'],
	\ ['Clear state', 'call dein#clear_state()'],
	\ ['Install new plugins', 'call dein#install()'],
	\]
let s:menus.terminal = {'description': 'Terminal'}
let s:menus.terminal.command_candidates = [
	\ ['Open terminal in new tab', 'tabnew | exec "terminal" | startinsert'],
	\]


" merge all menu items to single group
let s:u_all = []
let s:u_max_prefix_length = 0
for [k, v] in items(s:menus)
	if s:u_max_prefix_length < len(v.description)
		let s:u_max_prefix_length = len(v.description)
	endif
	for item in v.command_candidates
		call add(s:u_all, [v.description, item[0], item[1]])
	endfor
endfor
let s:u_all_pfx = []
for item in s:u_all
	let s:u_desc = item[0]
	while len(s:u_desc) < s:u_max_prefix_length
		let s:u_desc = s:u_desc . ' '
	endwhile
	call add(s:u_all_pfx, [s:u_desc . ' | ' . item[1], item[2]])
endfor
let s:menus.all = { 'description': 'All actions' }
let s:menus.all.command_candidates = s:u_all_pfx
unlet s:u_all
unlet s:u_all_pfx
unlet s:u_max_prefix_length
unlet s:u_desc

try
	call denite#custom#var('menu', 'menus', s:menus)
catch
	if stridx(v:exception, ':E117:') == -1 | echoe v:exception | endif
endtry
