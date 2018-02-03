" backups and swap config
" Author: Viacheslav Lotsmanov

set backup
set undofile

let s:my_backup_dir = $HOME . '/.vim_backup'
if !isdirectory(s:my_backup_dir) | call mkdir(s:my_backup_dir) | endif
let &backupdir = s:my_backup_dir . ',.,/tmp'

let s:my_swap_dir = $HOME . '/.vim_swap'
if !isdirectory(s:my_swap_dir) | call mkdir(s:my_swap_dir) | endif
let &directory = s:my_swap_dir . ',.,/tmp'

let s:my_undo_dir = $HOME . '/.vim_undo'
if !isdirectory(s:my_undo_dir) | call mkdir(s:my_undo_dir) | endif
let &undodir = s:my_undo_dir . ',.,/tmp'

" vim: set noet :
