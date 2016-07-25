"autocmd commands
"Author: Viacheslav Lotsmanov

if has('autocmd')
	
	autocmd BufNewFile,BufRead
		\ *.json.example,.jshintrc,.babelrc,.eslintrc,.modernizrrc
		\ set ft=json
	autocmd BufNewFile,BufRead *.gyp set ft=json
	autocmd BufNewFile,BufRead *.yaml.example set ft=yaml
	autocmd BufNewFile,BufRead *.ts set ft=typescript
	autocmd BufNewFile,BufRead *.tsx set ft=typescript.jsx
	autocmd BufNewFile,BufRead Makefile set noexpandtab
	autocmd BufNewFile,BufRead nginx.conf set ft=nginx
	
	" because some custom `indentexpr`s has annoying issues
	autocmd FileType
		\ ls,coffee,stylus,jade,html,jst,sh,faust,javascript.jsx,typescript.jsx
		\ set indentexpr=
	
	" haskell default indentation config
	autocmd FileType haskell,cabal setlocal et ts=2 sts=2 sw=2
	
	autocmd FileType python setlocal ts=4 sts=4 sw=4
	
	" disable tabs highlight on empty lines
	autocmd BufRead * syntax match whitespaceEOL /\s\+$/
endif

"vim: set noet :
