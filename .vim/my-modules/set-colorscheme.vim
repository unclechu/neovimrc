"set colorscheme stuff
"Author: Viacheslav Lotsmanov

"required install colorschemes by vundle first
try
	let g:colorscheme = 'solarized'

	"terminal mode
	if !has("gui_running")
		let g:colorscheme = 'darkburn'
	endif

	set t_Co=256

	exec 'colorscheme ' . g:colorscheme

	"overwrite SpecialKey for tabs highlight
	if g:colorscheme == 'solarized'
		hi SpecialKey guifg=#f4ce81 ctermfg=222 guibg=#efefce ctermbg=230
	else
		hi SpecialKey guifg=#340 ctermfg=53 guibg=#111 ctermbg=234
	endif
catch
endtry

"vim: set noet :
