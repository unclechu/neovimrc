"custom tabline
"Author: Viacheslav Lotsmanov
"TODO: tabline for CLI

function! GuiTabLabel()
	let l:label = ''
	let l:bufnrlist = tabpagebuflist(v:lnum)
	
	for l:bufnr in l:bufnrlist
		if getbufvar(l:bufnr, "&modified")
			let l:label = '+'
			break
		endif
	endfor
	
	let l:label .= v:lnum . ': '
	
	let l:name = bufname(l:bufnrlist[tabpagewinnr(v:lnum) - 1])
	
	if l:name == ''
		if &buftype == 'quickfix'
			let l:name = '[Quickfix List]'
		else
			let l:name = '[No Name]'
		endif
	else
		let l:dirname = fnamemodify(l:name, ':p:h')
		let l:tail = fnamemodify(l:name, ':p:t')
		let l:name = l:tail
		
		" shortify paths
		if l:dirname != ''
			" remove path to current dir
			let l:cwd = getcwd()
			let l:dirnameLeftPart = strpart(l:dirname, 0, strlen(l:cwd))
			if l:cwd == l:dirnameLeftPart
				let l:dirname = strpart(l:dirname, strlen(l:cwd) + 1)
			endif
			
			" shortify
			let l:dirname = substitute(l:dirname, '\([^/]\)[^/]\+', '\1', 'g')
			if l:dirname != ''
				let l:name = l:dirname . '/' . l:name
			endif
		endif
	endif
	
	let l:label .= l:name
	
	return l:label
endfunction

set guitablabel=%{GuiTabLabel()}

"vim: set noet :
