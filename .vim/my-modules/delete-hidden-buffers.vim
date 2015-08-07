"delete hidden buffers
"Source: http://stackoverflow.com/a/8459043/774228

function! DeleteHiddenBuffers()
	let tpbl=[]
	call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
	for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
		silent execute 'bwipeout' buf
	endfor
endfunction

command! DeleteHiddenBuffers call DeleteHiddenBuffers()

"vim: set noet :
