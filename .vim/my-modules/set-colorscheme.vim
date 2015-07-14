"set colorscheme stuff
"Author: Viacheslav Lotsmanov

"required install colorschemes by vundle first
try
	"terminal mode
	if has("gui_running")
		let g:colorscheme = 'solarized'
	else
		let g:colorscheme = 'darkburn'
	endif
	
	set t_Co=256
	
	exec 'colorscheme ' . g:colorscheme
	
	"overwrite SpecialKey for tabs highlight
	if has("gui_running")
		hi! NonText          guifg=#fdecc9
		hi! SpecialKey       guibg=#fdf5e5 guifg=#fd5570
		hi! IndentGuidesOdd  guibg=#efefce guifg=#f4ce81
		hi! IndentGuidesEven guibg=#ededc2 guifg=#f4ce81
	else
		hi! IndentGuidesOdd  ctermbg=233 ctermfg=237
		hi! IndentGuidesEven ctermbg=232 ctermfg=237
	endif
catch
endtry

"vim: set noet :
