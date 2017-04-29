" backups and swap config
" Author: Viacheslav Lotsmanov

set backup
let s:backups_and_swap_home_dir = $HOME
let s:tmp_dir = s:backups_and_swap_home_dir . '/.vim_backup'

if !isdirectory(s:tmp_dir)
	call mkdir(s:tmp_dir)
endif

let &backupdir = s:tmp_dir . ',.,/tmp'
let s:tmp_dir = s:backups_and_swap_home_dir . '/.vim_swap'

if !isdirectory(s:tmp_dir)
	call mkdir(s:tmp_dir)
endif

let &directory = s:tmp_dir . ',.,/tmp'

" vim: set noet :
