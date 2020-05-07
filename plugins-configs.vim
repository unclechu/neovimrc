" custom configs of plugins
" Author: Viacheslav Lotsmanov

let g:fzf_colors = {
	\ 'fg':      ['fg', 'Normal'],
	\ 'bg':      ['bg', 'Normal'],
	\ 'hl':      ['fg', 'Comment'],
	\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
	\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
	\ 'hl+':     ['fg', 'Statement'],
	\ 'info':    ['fg', 'PreProc'],
	\ 'border':  ['fg', 'Ignore'],
	\ 'prompt':  ['fg', 'Conditional'],
	\ 'pointer': ['fg', 'Exception'],
	\ 'marker':  ['fg', 'Keyword'],
	\ 'spinner': ['fg', 'Label'],
	\ 'header':  ['fg', 'Comment']
	\ }

let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_disable_at_vimenter = 1

let loaded_delimitMate = 0

let NERDTreeIgnore = ['\.swp', '\.swo', '\.pyc', '__pycache__']
let NERDTreeShowHidden = 1 " always show hidden files in NERDTree
let NERDTreeShowLineNumbers = 1
let NERDTreeWinSize = 40
let NERDTreeMapHelp = '<Leader>?' " heals backward search
let NERDTreeMapOpenSplit = 'ss'
let NERDTreeMapPreviewSplit = 'gss'
let NERDTreeMapOpenVSplit = 'sv'
let NERDTreeMapPreviewVSplit = 'gsv'
let NERDTreeNodeDelimiter = "\u00a0" " to fix ^G appearing after copy-paste
let NERDTreeHijackNetrw = 0

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
let g:airline#extensions#ale#enabled                     = 1

fu! s:LineNoIndicatorFuncPlug()
	if exists('*LineNoIndicator')
		let g:LineNoIndicatorFuncRef = function('LineNoIndicator')
		retu g:LineNoIndicatorFuncRef()
	el
		retu ''
	en
endf

" Using a plug function in case the "LineNoIndicator" isn't defined yet
" (when the plug-in is not installed yet), it (the plug function) will
" override the reference with real plug-in function when it's defined.
" For some reason even when the plugin is installed the plug function isn't
" ready yet on initialization stage.
let g:LineNoIndicatorFuncRef = function('s:LineNoIndicatorFuncPlug')

let g:airline_section_z
	\ = '░%#__accent_bold#%{g:LineNoIndicatorFuncRef()}%#__restore__#░'
	\ . '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#'
	\ . '%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v'

let g:line_no_indicator_bar_repeats = 7
let g:line_no_indicator_chars =
	\ reverse([' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'])

let g:CtrlSpaceDefaultMappingKey = '<C-Space>'
let g:CtrlSpaceUseArrowsInTerm   = 1
let g:CtrlSpaceUseTabline        = 0
try
	cal ctrlspace#api#Tabline() " will fail if function does not exists
	fu! CtrlSpaceTablineOwnWrap()
		let l:sep = '≡'
		let l:x = substitute(
			\ ctrlspace#api#Tabline(),
			\ '\( \)\@<=%[0-9]\+T%[^ ]\+', '%#TabLine#'.l:sep.'&', 'g')
		retu l:x
	endf
	se tal=%!CtrlSpaceTablineOwnWrap()
cat
	if !exists('plug_home') || stridx(v:exception, ':E117:') == -1
		echoe v:exception
	en
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

let g:tsuquyomi_disable_quickfix = 1

let g:haskellmode_completion_ghc = 0 " disable haskell-vim omnifunc

let g:LanguageClient_serverCommands = {
	\   'haskell': ['hie-wrapper'],
	\ }
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_completion_enabled = 0

let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable_nerdtree = 0 " disabled because it is laggy and buggy
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 1

let g:perl6_unicode_abbrevs = 0

let g:vim_json_syntax_conceal = 0

let g:indexed_search_mappings = 0
let g:indexed_search_numbered_only = 1

let g:smoothie_update_interval = 20
let g:smoothie_base_speed = 4
let g:smoothie_break_on_reverse = 0

let g:limelight_default_coefficient = 0.75
com! -nargs=? -bar -bang -range LL
	\ <line1>,<line2>cal limelight#execute(<bang>0, <count> > 0, <f-args>)
	\ | cal ColorschemeCustomizations()
com! -nargs=? -bar -bang GG
	\ cal goyo#execute(<bang>0, <q-args>)
	\ | cal ColorschemeCustomizations()
