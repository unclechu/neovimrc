"tabs highlight
"Author: Viacheslav Lotsmanov

let g:listchars_original=&listchars
let g:listchars_onlytab='tab:>-'

function! TabsHLEnable(silent)
	let l:lc = &listchars
	if l:lc != g:listchars_onlytab
		let &listchars = g:listchars_onlytab
		let l:tab_n = tabpagenr()
		let l:win_n = winnr()
		tabdo windo set list
		exec 'tabn' . l:tab_n
		exec l:win_n . 'wincmd w'
		let g:listchars_original = l:lc
	endif
	if a:silent != 1
		echo 'Tabs highlighting is enabled'
	endif
endfunction

function! TabsHLDisable(silent)
	let l:lc = &listchars
	if l:lc == g:listchars_onlytab
		let &listchars = g:listchars_original
		let l:tab_n = tabpagenr()
		let l:win_n = winnr()
		tabdo windo set nolist
		exec 'tabn' . l:tab_n
		exec l:win_n . 'wincmd w'
	endif
	if a:silent != 1
		echo 'Tabs highlighting is disabled'
	endif
endfunction

function! TabsHLToggle(silent)
	let l:lc = &listchars
	if l:lc != g:listchars_onlytab
		call TabsHLEnable(a:silent)
	else
		call TabsHLDisable(a:silent)
	endif
endfunction

command TabsHLEnable call TabsHLEnable(0)
command TabsHLDisable call TabsHLDisable(0)
command TabsHLToggle call TabsHLToggle(0)

"vim: set noet :
