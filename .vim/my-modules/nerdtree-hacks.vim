"NERDTree hacks
"Author: Viacheslav Lotsmanov

function! NewTabWithNERDTree()
	tabnew
	NERDTreeMirrorToggle
endfunction
command NewTabWithNERDTree call NewTabWithNERDTree()

"vim: set noet :
