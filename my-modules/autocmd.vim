" autocmd commands
" Author: Viacheslav Lotsmanov

" The purpuse of separating hooks to own functions is that they could be purely
" reloaded but `autocmd` couldn't, because it appends, reloading `autocmd`
" causes additional bindings.

function! s:InsertEnterHook()
	if &relativenumber
		let b:__had_relative_number_enabled = 1
		set norelativenumber
	endif
endfunction

function! s:InsertLeaveHook()
	set iminsert=0 " reset layout to default (en)
	if exists('b:__had_relative_number_enabled')
		if b:__had_relative_number_enabled | set relativenumber | endif
		unlet b:__had_relative_number_enabled
	endif
endfunction

function! s:CmdlineLeaveHook()
	set iminsert=0 " reset layout to default (en)
endfunction

function! s:TermOpenHook()
	set number
	if &g:relativenumber | set relativenumber | endif
endfunction

function! s:PreviousTab_StoreState()
	let s:tab_current = tabpagenr()
	let s:tab_last = tabpagenr('$')
endfunction

function! s:PreviousTab_TabClosed()
	if s:tab_current > 1 && s:tab_current < s:tab_last
		exec 'tabp'
	endif
endfunction

function! s:AnyBufEnterHook()
	if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()
		q
	endif
endfunction

function! s:AnyBufReadPostHook()
	" disable tabs highlight on empty lines
	syntax match whitespaceEOL /\s\+$/
endfunction

function! s:AnyBufWritePostHook()
	Neomake
endfunction

function! s:HaskellFTHook()
	setlocal et ts=2 sts=2 sw=2
	call g:ColorschemeCustomizations()
endfunction

function! s:CabalFTHook()
	setlocal et ts=2 sts=2 sw=2
endfunction

function! s:PythonFTHook()
	setlocal ts=4 sts=4 sw=4
endfunction

function! s:NimFTHook()
	" nnoremap <buffer> <c-]> :NimDefinition<cr>
	" nnoremap <buffer> gf    :call util#goto_file()<cr>
endfunction

function! s:GitcommitFTHook()
	setlocal cc=73 tw=72
endfunction

function! s:NerdtreeFTHook()
	setlocal nolist
endfunction

" so anything below won't be executed during config reload
if exists('s:loaded') | finish | endif

" Auto-close NERDTree window if it is only window on the screen
autocmd BufEnter * call s:AnyBufEnterHook()

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

" because some custom `indentexpr`s has annoying issues
autocmd FileType
	\ ls,coffee,stylus,jade,html,jst,sh,faust,javascript.jsx,typescript.jsx,
	\haskell,purescript
	\ set indentexpr=

autocmd FileType haskell call s:HaskellFTHook()
autocmd FileType cabal call s:CabalFTHook()
autocmd FileType python call s:PythonFTHook()
autocmd FileType nim call s:NimFTHook()
autocmd FileType gitcommit call s:GitcommitFTHook()
autocmd FileType nerdtree call s:NerdtreeFTHook()

autocmd InsertEnter * call s:InsertEnterHook()
autocmd InsertLeave * call s:InsertLeaveHook()

try
	autocmd CmdlineLeave * call s:CmdlineLeaveHook()
catch
	" Older version of Neovim could not have `CmdlineLeave` group
	if stridx(v:exception, 'E216:') == -1 | echoe v:exception | endif
endtry

autocmd TermOpen * call s:TermOpenHook()

autocmd TabEnter,TabLeave * call s:PreviousTab_StoreState()
autocmd TabClosed * call s:PreviousTab_TabClosed()
autocmd BufRead * call s:AnyBufReadPostHook()
autocmd BufWritePost * call s:AnyBufWritePostHook()

let s:loaded = 1

" vim: set noet :
