"indent size
"Author: Viacheslav Lotsmanov

" hack for closing NERDTree in all tabs before trigger :mksession
function! SaveSession(bang, filepath)
	
	let l:store = g:nerdtree_tabs_open_on_new_tab
	let g:nerdtree_tabs_open_on_new_tab = 0
	
	let l:lasttabn  = tabpagenr()
	let l:totaltabn = tabpagenr('$')
	let l:curtabn   = 1
	
	while l:curtabn <= l:totaltabn
		exec 'tabnext ' . l:curtabn
		exec 'NERDTreeClose'
		let l:curtabn = l:curtabn + 1
	endwhile
	
	" restore last opened tab
	exec 'tabnext ' . l:lasttabn
	
	if a:bang == 1
		exec 'mksession! ' . a:filepath
	else
		exec 'mksession ' . a:filepath
	endif
	
	let g:nerdtree_tabs_open_on_new_tab = l:store
	
endfunction

command! -nargs=1 -complete=file SS call SaveSession(0, <q-args>)
command! -nargs=1 -complete=file -bang SS call SaveSession(<bang>0, <q-args>)

" for prevent default NERDTree windows focused after restore session
function! RestoreSession()
	
	let l:lasttabn  = tabpagenr()
	let l:totaltabn = tabpagenr('$')
	let l:curtabn   = 1
	
	while l:curtabn <= l:totaltabn
		exec 'tabnext ' . l:curtabn
		exec 'wincmd l'
		let l:curtabn = l:curtabn + 1
	endwhile
	
	" restore last opened tab
	exec 'tabnext ' . l:lasttabn
	
endfunction

command RS call RestoreSession()

"vim: set noet :
