" autocmd commands
" Author: Viacheslav Lotsmanov

aug my#auto_filetype_detection | au!
	au BufNewFile,BufRead
		\ *.json.example,.jshintrc,.babelrc,.eslintrc,.prettierrc,.modernizrrc
		\ se ft=json

	au BufNewFile,BufRead
		\ *.yaml.example,*.yaml.default,*.yaml.sample,stack.yaml.lock
		\ se ft=yaml

	au BufNewFile,BufRead nginx.conf se ft=nginx
	au BufNewFile,BufRead *.gyp se ft=json
	au BufNewFile,BufRead *.tfstate se ft=json
	au BufNewFile,BufRead *.ts se ft=typescript
	au BufNewFile,BufRead *.tsx se ft=typescript.jsx
	au BufNewFile,BufRead *.hsc se ft=haskell
	au BufNewFile,BufRead *.nj se ft=jinja
	au BufNewFile,BufRead Vagrantfile se ft=ruby
	au BufNewFile,BufRead .ssh-vagrant se ft=sshconfig
aug END

aug my#filetype_hooks | au!
	" because some custom `indentexpr`s has annoying issues
	au FileType
		\ ls,coffee,stylus,jade,html,jst,sh,faust,javascript.jsx,typescript.jsx,
		\haskell,purescript,tcl,vim,markdown,yaml,nix
		\ setl inde=

	au FileType Makefile setl noet

	fu! s:highlight_haskell_qm_interpolation_blocks()
		sy match haskellQMStr "." containedin=haskellQM contained

		sy region haskellQMBlock matchgroup=haskellDelimiter
			\ start="\(^\|\(^\|[^\\]\)\(\\\\\)*\)\@<={" end="}"
			\ contains=TOP,@Spell containedin=haskellQM contained

		sy region haskellQM matchgroup=haskellTH
			\ start="\[qm\(b\|s\)\?|" end="|\]"

		hi def link haskellQMStr String
	endf

	au FileType haskell
		\ setl et ts=2 sts=2 sw=2
		\ | cal g:ColorschemeCustomizations()
		\ | cal s:highlight_haskell_qm_interpolation_blocks()

	au FileType cabal setl et ts=2 sts=2 sw=2
	au FileType python setl ts=4 sts=4 sw=4

	" au FileType nim
	" 	\ nn <buffer> <c-]> :NimDefinition<cr>
	" 	\ | nn <buffer> gf :cal util#goto_file()<cr>

	au FileType gitcommit setl cc=73 tw=72
	au FileType nerdtree setl nolist
	au FileType markdown setl et ts=2 sts=2 sw=2
	au FileType org setl tw=0

	au BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt
		\ sil %!pandoc -tplain -o /dev/stdout -- '%'
aug END

aug my#insert_mode_hooks | au!
	au InsertEnter *
		\ if &rnu | let b:__had_relative_number_enabled = 1 | se nornu | en
	au InsertLeave *
		\ se imi=0
		\ | if exists('b:__had_relative_number_enabled')
		\ |   if b:__had_relative_number_enabled | se rnu | en
		\ |   unl b:__had_relative_number_enabled
		\ | en

	fu! s:insert_leave_autosave()
		let l:f = expand('%')
		if &ro || l:f == '' || l:f == '[Command Line]' | retu | en
		if exists('b:insert_leave_autosave_enabled')
			if b:insert_leave_autosave_enabled | up | en
		elsei g:insert_leave_autosave_enabled | up | en
	endf

	au InsertLeave * cal s:insert_leave_autosave()
aug END

aug my#cmd_mode_hooks | au!
	try
		" reset layout to default (en)
		au CmdlineLeave * se imi=0
	cat
		" Older version of Neovim could not have `CmdlineLeave` group
		if stridx(v:exception, 'E216:') == -1 | echoe v:exception | en
	endt
aug END

aug my#term_mode_hooks | au!
	au TermOpen * se nu | if &rnu | se rnu | en
aug END

aug my#tabs_hooks | au!
	au TabEnter,TabLeave *
		\ let s:tab_current = tabpagenr() | let s:tab_last = tabpagenr('$')
	au TabClosed *
		\ if s:tab_current > 1 && s:tab_current < s:tab_last | exe 'tabp' | en
aug END

aug my#buffers_hooks | au!
	" disable tabs highlight on empty lines
	au BufRead * sy match whitespaceEOL /\s\+$/

	au BufWritePost * Neomake

	" Auto-close NERDTree window if it is only window on the screen
	au BufEnter *
		\ if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()
		\ | q | en
aug END

" vim: se noet :
