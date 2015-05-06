"tabs highlight
"Author: Viacheslav Lotsmanov

let g:listchars_original=&listchars
let g:listchars_onlytab='tab:>-'

function! ToggleTabsHL(silent)
	let l:lc = &listchars
	if l:lc == g:listchars_onlytab
		let &listchars = g:listchars_original
		let l:tab_n = tabpagenr()
		let l:win_n = winnr()
		tabdo windo set nolist
		exec 'tabn' . l:tab_n
		exec l:win_n . 'wincmd w'
		if a:silent != 1
			echo 'Tabs highlighting is disabled'
		endif
	else
		let &listchars = g:listchars_onlytab
		let l:tab_n = tabpagenr()
		let l:win_n = winnr()
		tabdo windo set list
		exec 'tabn' . l:tab_n
		exec l:win_n . 'wincmd w'
		let g:listchars_original = l:lc
		if a:silent != 1
			echo 'Tabs highlighting is enabled'
		endif
	endif
endfunction
command ToggleTabsHL call ToggleTabsHL(0)

"vim: set noet :
