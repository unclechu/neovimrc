"set colorscheme stuff
"Author: Viacheslav Lotsmanov

"required install colorschemes by vundle first
try
	if has('gui_running')
		
		let g:colorscheme = 'solarized'
		
		set t_Co=256
		exec 'colorscheme ' . g:colorscheme
		
		hi! NonText          guifg=#fdecc9
		hi! SpecialKey       guibg=#fdf5e5 guifg=#fd5570
		hi! IndentGuidesOdd  guibg=#efefce guifg=#f4ce81
		hi! IndentGuidesEven guibg=#ededc2 guifg=#f4ce81
	else
		exec 'colorscheme default'
	endif
catch
endtry

"vim: set noet :
