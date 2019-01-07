" custom configs of plugins
" Author: Viacheslav Lotsmanov

let g:dein#install_process_timeout = 3600 " some reaches timeout

let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_disable_at_vimenter = 1

let NERDTreeIgnore = ['\.swp', '\.swo', '\.pyc', '__pycache__']
let NERDTreeShowHidden = 1 " always show hidden files in NERDTree
let NERDTreeShowLineNumbers = 1
let NERDTreeWinSize = 40
let NERDTreeMapHelp = '<Leader>?' " heals backward search
let NERDTreeMapOpenSplit = 'ss'
let NERDTreeMapPreviewSplit = 'gss'
let NERDTreeMapOpenVSplit = 'sv'
let NERDTreeMapPreviewVSplit = 'gsv'

let g:nerdtree_tabs_open_on_gui_startup     = 0
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_new_tab         = 0

let g:tagbar_show_linenumbers               = 2

let g:airline_powerline_fonts                            = 1
let g:airline#extensions#tabline#enabled                 = 0
let g:airline#extensions#tabline#show_buffers            = 0
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#whitespace#enabled              = 0
let g:airline#extensions#keymap#enabled                  = 0
let g:airline#extensions#branch#enabled                  = 0

let g:CtrlSpaceDefaultMappingKey = '<C-Space>'
let g:CtrlSpaceUseArrowsInTerm   = 1
let g:CtrlSpaceUseTabline        = 0
try
	call ctrlspace#api#Tabline() " will fail if function does not exists
	fu! CtrlSpaceTablineOwnWrap()
		let l:sep = '≡'
		let l:x = substitute(
			\ ctrlspace#api#Tabline(),
			\ '\( \)\@<=%[0-9]\+T%[^ ]\+', '%#TabLine#'.l:sep.'&', 'g')
		return l:x
	endf
	se tal=%!CtrlSpaceTablineOwnWrap()
cat
	if stridx(v:exception, ':E117:') == -1 | echoe v:exception | endif
endt

let g:indentLine_enabled = 0
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_exclude_filetypes =
	\ ['help', 'nerdtree', 'tagbar', 'clojure', 'haskell', 'cabal', 'startify']

let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:UltiSnipsExpandTrigger            = '<Nul>'
let g:UltiSnipsListSnippets             = '<Nul>'
" remapped from <C-j/k> to <A-j/k> to reduce conflicts with digraphs map ^K
let g:UltiSnipsJumpForwardTrigger       = '<A-j>'
let g:UltiSnipsJumpBackwardTrigger      = '<A-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0

" let g:syntastic_enable_signs = 1
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 2
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" let g:syntastic_loc_list_height = 5
" let g:syntastic_enable_highlighting = 0
" let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint']
" let g:syntastic_python_checkers = ['python']
" let g:syntastic_python_python_exec = '/usr/bin/python3'

let g:flow#enable = 0

let g:user_emmet_leader_key = '<C-Z>'
let g:user_emmet_settings = {
	\  'javascript.jsx' : { 'extends' : 'jsx' },
	\  'typescript.jsx' : { 'extends' : 'jsx' },
	\ }

let g:nvim_nim_enable_default_binds = 0

let g:EasyMotion_do_mapping = 0 " disable default mappings
let g:EasyMotion_smartcase = 1 " turn on case insensitive feature

let g:gitgutter_map_keys = 0

let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1

let g:tsuquyomi_disable_quickfix = 1

let g:haskellmode_completion_ghc = 0 " disable haskell-vim omnifunc

let g:LanguageClient_serverCommands = {
	\   'haskell': ['hie-wrapper'],
	\ }
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_completion_enabled = 1

let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable_nerdtree = 0 " disabled because it is laggy and buggy
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 1

let g:perl6_unicode_abbrevs = 0

let g:indexed_search_mappings = 0
let g:indexed_search_numbered_only = 1

try
	call denite#custom#filter(
		\ 'matcher_ignore_globs',
		\ 'ignore_globs',
		\ [ '.git/', '.hg/', '.bzr/', '.svn/',
		\   '.cabal-sandbox/', '.stack-work/',
		\   '.ropeproject/', '__pycache__/', 'venv/', '.venv/', '*.pyc',
		\   'node_modules/', 'bower_components/',
		\   '*.exe', '*.so', '*.dll',
		\   '*.sw[po]', '*.bak', '*~', '*.o'
		\ ])

	call denite#custom#source('file_rec', 'matchers', ['matcher_ignore_globs'])

	call denite#custom#alias('source', 'file_rec/git', 'file_rec')
	call denite#custom#var(
		\ 'file_rec/git',
		\ 'command',
		\ ['git', 'ls-files', '-co', '--exclude-standard']
		\)

	call denite#custom#alias('source', 'grep/git', 'grep')
	call denite#custom#var(
		\ 'grep/git',
		\ 'command',
		\ ['git', 'grep', '-n', '--no-color'])
	call denite#custom#var('grep/git', 'default_opts', [])
	call denite#custom#var('grep/git', 'recursive_opts', [])
	call denite#custom#var('grep/git', 'pattern_opt', [])
	call denite#custom#var('grep/git', 'separator', ['--'])
	call denite#custom#var('grep/git', 'final_opts', ['.'])

	call denite#custom#source('grep', 'converters', ['converter_abbr_word'])
	call denite#custom#source('grep/git', 'converters', ['converter_abbr_word'])

	" TODO FIXME denite
	" call denite#custom#source('file_rec', 'max_candidates', 10)
	" let g:unite_source_hoogle_max_candidates = 1000 " for haskell

	call denite#custom#option('default', 'prompt', 'λ')
	call denite#custom#option('default', 'smartcase', 1)
catch
	if stridx(v:exception, ':E117:') == -1 | echoe v:exception | endif
endtry
