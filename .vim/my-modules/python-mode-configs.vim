"python-mode plugin configs
"Author: Viacheslav Lotsmanov

let g:pymode_rope = 0
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
let g:pymode_lint_cwindow = 0
let g:pymode_lint_options_pep8 = {
		\ 'max_line_length': 80,
		\ 'ignore': 'W191'
	\ }
let g:pymode_virtualenv = 1
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all
"let g:pymode_folding = 0
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>e'

"vim: set noet :
