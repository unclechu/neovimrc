"backups and swap config
"Author: Viacheslav Lotsmanov

set backup

let g:backups_and_swap_home_dir = expand('~')

let g:tmp_dir = g:backups_and_swap_home_dir . '/.vim_backup'
if !isdirectory(g:tmp_dir)
	call mkdir(g:tmp_dir)
endif
let &backupdir = g:tmp_dir . ',.,/tmp'

let g:tmp_dir = g:backups_and_swap_home_dir . '/.vim_swap'
if !isdirectory(g:tmp_dir)
	call mkdir(g:tmp_dir)
endif
let &directory = g:tmp_dir . ',.,/tmp'

unlet g:backups_and_swap_home_dir
unlet g:tmp_dir

"vim: set noet :
