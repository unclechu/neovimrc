"autocmd commands
"Author: Viacheslav Lotsmanov

autocmd BufNewFile,BufRead
	\ *.json.example,.jshintrc,.babelrc,.eslintrc,.modernizrrc
	\ set ft=json
autocmd BufNewFile,BufRead *.gyp set ft=json
autocmd BufNewFile,BufRead *.yaml.example set ft=yaml
autocmd BufNewFile,BufRead *.ts set ft=typescript
autocmd BufNewFile,BufRead *.tsx set ft=typescript.jsx
autocmd BufNewFile,BufRead Makefile set noexpandtab
autocmd BufNewFile,BufRead nginx.conf set ft=nginx
autocmd BufNewFile,BufRead *.hsc set ft=haskell

" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" because some custom `indentexpr`s has annoying issues
autocmd FileType
	\ ls,coffee,stylus,jade,html,jst,sh,faust,javascript.jsx,typescript.jsx
	\ set indentexpr=

" haskell default indentation config
autocmd FileType haskell,cabal setlocal et ts=2 sts=2 sw=2

autocmd FileType python setlocal ts=4 sts=4 sw=4

" disable tabs highlight on empty lines
autocmd BufRead * syntax match whitespaceEOL /\s\+$/

autocmd InsertEnter * set norelativenumber
autocmd InsertLeave * set relativenumber

" fix easymotion bug https://github.com/easymotion/vim-easymotion/issues/294
autocmd WinLeave * silent

autocmd TermOpen * set number relativenumber

function! s:PreviousTab_StoreState()
	let s:tab_current = tabpagenr()
	let s:tab_last = tabpagenr('$')
endfunction
function! s:PreviousTab_TabClosed()
	if s:tab_current > 1 && s:tab_current < s:tab_last
		exec 'tabp'
	endif
endfunction
autocmd TabEnter,TabLeave * call s:PreviousTab_StoreState()
autocmd TabClosed * call s:PreviousTab_TabClosed()

"vim: set noet :
