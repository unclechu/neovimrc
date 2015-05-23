"autocmd commands
"Author: Viacheslav Lotsmanov

if has('autocmd')
	autocmd BufNewFile,BufRead *.json.example set ft=json
	autocmd BufNewFile,BufRead *.gyp set ft=json
	autocmd BufNewFile,BufRead *.yaml.example set ft=yaml
	autocmd BufNewFile,BufRead Makefile set noexpandtab
	autocmd BufWritePre * call ClearSpacesAtEOF()
endif

"vim: set noet :
