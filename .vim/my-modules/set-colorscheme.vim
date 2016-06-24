"set colorscheme stuff
"Author: Viacheslav Lotsmanov

function! SetSolarized(mode)
	try
		
		set t_Co=256
		exec 'colorscheme solarized'
		
		if a:mode == 'light'
			
			set background=light
			
			hi! NonText          guifg=#fdecc9
			hi! SpecialKey       guibg=#fdf5e5 guifg=#fd5570
			hi! IndentGuidesOdd  guibg=#ede8d5 guifg=#f7f2de
			hi! IndentGuidesEven guibg=#f2edda guifg=#fcf7e3
		else
			set background=dark
			
			hi! NonText          guifg=#08333d
			hi! SpecialKey       guibg=#072f38 guifg=#fd5570
			hi! IndentGuidesOdd  guibg=#06323d guifg=#083a47
			hi! IndentGuidesEven guibg=#073642 guifg=#083f4d
		endif
		
		"highlight only line number
		hi! CursorLine ctermbg=NONE cterm=NONE guibg=NONE guisp=NONE
	catch
	endtry
endfunction

command! -nargs=1 SetSolarized call SetSolarized(<f-args>)

if has('gui_running')
	call SetSolarized('light')
else
	call SetSolarized('dark')
endif

"vim: set noet :
