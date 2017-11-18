" autocmd commands
" Author: Viacheslav Lotsmanov

if exists('s:loaded')
	finish
endif

" Auto-close NERDTree window if it is only window on the screen
autocmd BufEnter * if
	\ (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
	\ | q | endif

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

" autocmd FileType nim nnoremap <buffer> <c-]> :NimDefinition<cr>
" autocmd FileType nim nnoremap <buffer> gf    :call util#goto_file()<cr>

" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" because some custom `indentexpr`s has annoying issues
autocmd FileType
	\ ls,coffee,stylus,jade,html,jst,sh,faust,javascript.jsx,typescript.jsx,
	\haskell
	\ set indentexpr=

" haskell default indentation config
autocmd FileType haskell,cabal setlocal et ts=2 sts=2 sw=2

autocmd FileType python setlocal ts=4 sts=4 sw=4
autocmd FileType gitcommit setlocal cc=73 tw=72
autocmd FileType nerdtree setlocal nolist

" disable tabs highlight on empty lines
autocmd BufRead * syntax match whitespaceEOL /\s\+$/

function! s:InsertEnterHook()
	if &relativenumber
		let b:__had_relative_number_enabled = 1
		set norelativenumber
	endif
endfunction

function! s:InsertLeaveHook()
	if exists('b:__had_relative_number_enabled')
		if b:__had_relative_number_enabled | set relativenumber | endif
		unlet b:__had_relative_number_enabled
	endif
endfunction

autocmd InsertEnter * call s:InsertEnterHook()
autocmd InsertLeave * call s:InsertLeaveHook()

function! s:TermOpenHook()
	set number
	if &g:relativenumber | set relativenumber | endif
endfunction

autocmd TermOpen * call s:TermOpenHook()

" fix easymotion bug https://github.com/easymotion/vim-easymotion/issues/294
autocmd WinLeave * silent

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
autocmd BufWritePost * Neomake
let s:loaded = 1

" vim: set noet :
