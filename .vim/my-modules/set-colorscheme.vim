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
		hi SpecialKey       guibg=#efefce ctermbg=230 guifg=#f4ce81 ctermfg=222
		hi IndentGuidesOdd  guibg=#efefce ctermbg=229 guifg=#f4ce81 ctermfg=222
		hi IndentGuidesEven guibg=#ededc2 ctermbg=228 guifg=#f4ce81 ctermfg=222
	else
		hi SpecialKey       guibg=#111111 ctermbg=234 guifg=#333333 ctermfg=237
		hi IndentGuidesOdd  guibg=#111111 ctermbg=233 guifg=#333333 ctermfg=237
		hi IndentGuidesEven guibg=#222222 ctermbg=232 guifg=#333333 ctermfg=237
	endif
catch
endtry

"vim: set noet :
