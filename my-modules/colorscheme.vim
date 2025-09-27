" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

" :terminal colorscheme
let g:terminal_color_0 = '#073642'
let g:terminal_color_1 = '#dc322f'
let g:terminal_color_2 = '#859900'
let g:terminal_color_3 = '#b58900'
let g:terminal_color_4 = '#268bd2'
let g:terminal_color_5 = '#d33682'
let g:terminal_color_6 = '#2aa198'
let g:terminal_color_7 = '#eee8d5'
let g:terminal_color_8 = '#002b36'
let g:terminal_color_9 = '#cb4b16'
let g:terminal_color_10 = '#586e75'
let g:terminal_color_11 = '#657b83'
let g:terminal_color_12 = '#839496'
let g:terminal_color_13 = '#6c71c4'
let g:terminal_color_14 = '#93a1a1'
let g:terminal_color_15 = '#fdf6e3'

" some colorschemes configurations

let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'soft'

let g:gruvbox_material_foreground = 'mix'
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_dim_inactive_windows = 1
let g:gruvbox_material_visual = 'reverse'
let g:gruvbox_material_menu_selection_background = 'orange'
" note that this for the bg=hard
" swapping normal (active window) and dim background (I prefer it this way)
let g:gruvbox_material_colors_override =
	\ {
	\ 'bg_dim': ['#1d2021', '234'],
	\ 'bg0': ['#141617', '232'],
	\ }

let g:everforest_background = 'hard'
let g:everforest_enable_italic = 1

let g:edge_style = 'neon'
let g:edge_enable_italic = 1
" let g:edge_dim_inactive_windows = 0
let g:edge_transparent_background = 1

let g:sonokai_style = 'espresso'

lua require('onedark').setup({style='warmer'})

lua << EOF
	require('nightfox').setup({
		options = {
			styles = {
				comments = 'italic',
				keywords = 'bold',
				types = 'italic,bold',
			},
		},
	})
EOF

lua << EOF
	require('kanagawa').setup({
		-- Done in `overrides`.
		dimInactive = false,
		-- Swap background color for active and inactive window
		-- (for `dimInactive` feature).
		overrides = function(colors)
			local theme = colors.theme
			local C = require("kanagawa.lib.color")
			local darker_nc = C(theme.ui.bg):blend("#000000", 0.15):to_hex()
			return {
				-- Active window: darker background
				Normal = { fg = theme.ui.fg, bg = theme.ui.bg_dim },
				-- Inactive windows: brighter background
				--NormalNC = { fg = theme.ui.fg_dim, bg = theme.ui.bg },
				-- Darken background more for inactive window, fix too much contrast
				NormalNC = { fg = theme.ui.fg_dim, bg = darker_nc },
			}
		end,
	})
EOF

lua << EOF
	require('rose-pine').setup({
		dim_inactive_windows = true, -- let us control Normal/NormalNC ourselves
		highlight_groups = {
			-- Active window: darker bg (base)
			Normal = { bg = 'base' },
			-- Inactive windows: brighter bg (overlay or surface)
			-- or 'overlay' for brighter inactive bg
			NormalNC = { bg = 'surface' },
		},
	})
EOF

lua << EOF
	require('tokyonight').setup({
		dim_inactive = false, -- let us control Normal/NormalNC ourselves
		on_highlights = function(hl, c)
			-- Active window: darker background
			hl.Normal = { fg = c.fg, bg = c.bg_dark }
			-- Inactive windows: brighter background
			hl.NormalNC = { fg = c.fg_dark or c.fg, bg = c.bg }
			-- Fix `cc` blending with active window background when using `tokyonight-night`
			local util = require("tokyonight.util")
			-- hl.ColorColumn = { bg = c.bg }
			-- Make it visible on inactive window too
			hl.ColorColumn = { bg = util.lighten(c.bg, 0.99) }
		end,
	})
EOF

lua << EOF
	require("catppuccin").setup({
		-- avoid theme-side dim when swapping [default false]
		dim_inactive = { enabled = false },
		custom_highlights = function(c)
			return {
				-- Active window (Normal): darker bg
				Normal = { fg = c.text, bg = c.mantle }, -- use c.crust for even darker
				-- Inactive windows (NormalNC): brighter bg
				NormalNC = { fg = c.subtext1, bg = c.base },
			}
		end,
	})
EOF

" Airline themes: gruvbox gruvbox_material sonokai everforest
" Examples:
" let g:airline_theme = 'gruvbox_material'
" AirlineTheme gruvbox_material

" something wrong with 'haskell-vim' syntax plugin, this dirty hack fixes it.
" it's just a copy from 'haskell-vim'
" but 'highlight def link' is replaced with 'hi! link'.
" XXX: Maybe I don’t need this hack anymore, I’m using TreeSitter plugin for
"      Haskell nowadays for quite a while already.
fu! s:fix_haskell_syntax()
	hi! link haskellBottom Macro
	hi! link haskellTH Boolean
	hi! link haskellIdentifier Identifier
	hi! link haskellForeignKeywords Structure
	hi! link haskellKeyword Keyword
	hi! link haskellDefault Keyword
	hi! link haskellConditional Conditional
	hi! link haskellNumber Number
	hi! link haskellFloat Float
	if g:colors_name == 'onedark'
	\|| g:colors_name == 'gruvbox'
	\|| g:colors_name == 'retrobox'
	\|| g:colors_name == 'codeschool'
		hi! link haskellSeparator Comment
		hi! link haskellDelimiter Comment
	el
		hi! link haskellSeparator Delimiter
		hi! link haskellDelimiter Delimiter
	en
	hi! link haskellInfix Keyword
	if g:colors_name == 'gruvbox'
	\|| g:colors_name == 'retrobox'
		hi! link haskellOperators Delimiter
		hi! link haskellQuote Delimiter
	elsei g:colors_name == 'OceanicNext'
		hi! link haskellOperators Keyword
		hi! link haskellQuote Keyword
	el
		hi! link haskellOperators Operator
		hi! link haskellQuote Operator
	en
	hi! link haskellShebang Comment
	hi! link haskellLineComment Comment
	hi! link haskellBlockComment Comment
	hi! link haskellPragma SpecialComment
	hi! link haskellLiquid SpecialComment
	hi! link haskellString String
	hi! link haskellChar String
	if g:colors_name == 'OceanicNext'
	\|| g:colors_name == 'gruvbox'
	\|| g:colors_name == 'retrobox'
		hi! link haskellBacktick Keyword
	el
		hi! link haskellBacktick Operator
	en
	hi! link haskellQuasiQuoted String
	hi! link haskellTodo Todo
	hi! link haskellPreProc PreProc
	hi! link haskellAssocType Type
	hi! link haskellQuotedType Type
	hi! link haskellType Type
	hi! link haskellImportKeywords Include
	if get(g:, 'haskell_classic_highlighting', 0)
		hi! link haskellDeclKeyword Keyword
		hi! link HaskellDerive Keyword
		hi! link haskellDecl Keyword
		hi! link haskellWhere Keyword
		hi! link haskellLet Keyword
	el
		hi! link haskellDeclKeyword Structure
		hi! link HaskellDerive Structure
		hi! link haskellDecl Structure
		hi! link haskellWhere Structure
		hi! link haskellLet Structure
	en

	if get(g:, 'haskell_enable_quantification', 0)
		if g:colors_name == 'OceanicNext'
			hi! link haskellForall Keyword
		el
			hi! link haskellForall Operator
		en
	en
	if get(g:, 'haskell_enable_recursivedo', 0)
		hi! link haskellRecursiveDo Keyword
	en
	if get(g:, 'haskell_enable_arrowsyntax', 0)
		hi! link haskellArrowSyntax Keyword
	en
	if get(g:, 'haskell_enable_static_pointers', 0)
		hi! link haskellStatic Keyword
	en
	if get(g:, 'haskell_classic_highlighting', 0)
		if get(g:, 'haskell_enable_pattern_synonyms', 0)
			hi! link haskellPatternKeyword Keyword
		en
		if get(g:, 'haskell_enable_typeroles', 0)
			hi! link haskellTypeRoles Keyword
		en
	el
		if get(g:, 'haskell_enable_pattern_synonyms', 0)
			hi! link haskellPatternKeyword Structure
		en
		if get(g:, 'haskell_enable_typeroles', 0)
			hi! link haskellTypeRoles Structure
		en
	en

	if get(g:, 'haskell_backpack', 0)
		hi! link haskellBackpackStructure Structure
		hi! link haskellBackpackDependency Include
	en
endf

fu! g:ColorschemeCustomizations()
	try
		cal s:fix_haskell_syntax()
		" Set these for any colorscheme
		"if g:colors_name == 'gruvbox' || g:colors_name == 'retrobox'
			hi! link TabLine     Folded
			hi! link TabLineFill Pmenu
			hi! link TabLineSel  airline_a_bold
		"en
	cat
		" handling default colorscheme
		if stridx(v:exception, ':E121:') == -1 | echoe v:exception | en
	endt

	" a fix for the multicursor selection highlighting for non gruvbox themes
	augroup MultiCursorsHighlight
		autocmd!
		" Strong, theme-adaptive linking
		autocmd ColorScheme * highlight link multiple_cursors_visual IncSearch
		autocmd ColorScheme * highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
	augroup END
endf

let g:colorschemes = []

let g:colorschemes_fav = [
	\ 'bamboo-vulgaris',
	\ 'carbonfox',
	\ 'catppuccin-mocha',
	\ 'cyberdream',
	\ 'gruvbox-material',
	\ 'jellybeans',
	\ 'kanagawa-dragon',
	\ 'kanagawa-wave',
	\ 'material-darker',
	\ 'material-deep-ocean',
	\ 'melange',
	\ 'moonfly',
	\ 'onedark',
	\ 'oxocarbon',
	\ 'rose-pine-main',
	\ 'sonokai',
	\ 'tokyodark',
	\ 'tokyonight-night',
	\ 'vscode',
	\ ]

fu! g:RefreshColorschemes()
	let g:colorschemes = map(
		\ globpath(&rtp, 'colors/*.vim', 0, 1), 'fnamemodify(v:val, ":t:r")')
	" FIXME: Some colorschemes are missing, adding them manually.
	"        Probably need to improve globpath or add another one.
	let g:colorschemes +=
		\ [ 'melange', 'nordic', 'nord', 'tokyodark', 'oxocarbon'
		\ , 'dracula', 'dracula-soft'
		\ , 'vscode', 'onedark'
		\ , 'cyberdream', 'cyberdream-light'
		\ ]
	" material.nvim themes
	let g:colorschemes +=
		\ [ 'material', 'material-darker', 'material-deep-ocean'
		\ , 'material-lighter', 'material-oceanic', 'material-palenight'
		\ ]
	" bamboo.nvim themes
	let g:colorschemes +=
		\ [ 'bamboo', 'bamboo-light', 'bamboo-multiplex', 'bamboo-vulgaris' ]
	" rose-pine themes
	let g:colorschemes +=
		\ [ 'rose-pine', 'rose-pine-dawn', 'rose-pine-moon', 'rose-pine-main' ]
	" tokyonight themes
	let g:colorschemes +=
		\ [ 'tokyonight', 'tokyonight-day', 'tokyonight-moon'
		\ , 'tokyonight-night', 'tokyonight-storm'
		\ ]
endf

cal RefreshColorschemes()

fu! g:SetColorscheme(colorscheme)
	if index(g:colorschemes, a:colorscheme) >= 0
		exec 'colo '.a:colorscheme
		cal ColorschemeCustomizations()

		" setting up Airline theme
		let l:x = a:colorscheme
		" TODO: refactor these overrides with a key-value mapping or something
		"       like it
		if l:x == 'gruvbox-material' | let l:x = 'gruvbox_material' | en
		if l:x == 'melange' | let l:x = 'gruvbox_material' | en
		if l:x == 'nordic' | let l:x = 'nord_minimal' | en
		if l:x == 'nord' | let l:x = 'nord_minimal' | en
		if l:x == 'tokyodark' | let l:x = 'tomorrow' | en
		if l:x == 'oxocarbon' | let l:x = 'one' | en
		if l:x == 'material' | let l:x = 'base16_material' | en
		if l:x == 'material-darker' | let l:x = 'base16_material_darker' | en
		if l:x == 'material-deep-ocean' | let l:x = 'base16_material_darker' | en
		if l:x == 'material-lighter' | let l:x = 'base16_material_lighter' | en
		if l:x == 'material-oceanic' | let l:x = 'base16_material_palenight' | en
		if l:x == 'material-palenight' | let l:x = 'base16_material_palenight' | en
		if l:x == 'dracula' | let l:x = 'base16_porple' | en
		if l:x == 'dracula-soft' | let l:x = 'base16_porple' | en
		if l:x == 'onedark_dark' | let l:x = 'onedark' | en
		if l:x == 'onedark_vivid' | let l:x = 'onedark' | en
		if l:x == 'carbonfox' | let l:x = 'atomic' | en
		if l:x == 'vscode' | let l:x = 'base16_material_vivid' | en
		if l:x == 'bamboo-vulgaris' | let l:x = 'moonfly' | en
		if l:x == 'cyberdream' | let l:x = 'jellybeans' | en
		if l:x == 'kanagawa' | let l:x = 'one' | en
		if l:x == 'kanagawa-wave' | let l:x = 'one' | en
		if l:x == 'kanagawa-dragon' | let l:x = 'one' | en
		if l:x == 'rose-pine' | let l:x = 'one' | en
		if l:x == 'rose-pine-moon' | let l:x = 'one' | en
		if l:x == 'rose-pine-main' | let l:x = 'one' | en
		if l:x == 'tokyonight' | let l:x = 'one' | en
		if l:x == 'tokyonight-day' | let l:x = 'one' | en
		if l:x == 'tokyonight-moon' | let l:x = 'one' | en
		if l:x == 'tokyonight-night' | let l:x = 'one' | en
		if l:x == 'tokyonight-storm' | let l:x = 'one' | en
		if l:x == 'catppuccin-mocha' | let l:x = 'catppuccin' | en
		" the command is not available at initialization time
		if exists(':AirlineTheme')
			exec 'AirlineTheme ' . l:x
		else
			let g:airline_theme = l:x
		endif
	el
		th 'Colorscheme "'.a:colorscheme.'" not found'
	en
endf

fu! s:complete(A, L, P)
	let l:x = copy(g:colorschemes)
	retu empty(a:A) ? l:x : filter(l:x, 'v:val[:strlen(a:A)-1] == a:A')
endf

com! RefreshColorschemes cal RefreshColorschemes()
com! -nargs=1 -complete=customlist,s:complete Colorscheme
	\ cal SetColorscheme(<q-args>)

" Check if a colorscheme is available
fu! g:HasColorscheme(name)
	retu index(g:colorschemes, a:name) >= 0
endf

fu! g:InitializeColorscheme()
	set background=dark

	" Switch to light colorscheme if detected my Tmux session in light colorscheme
	if $TMUX != '' && executable('tmuxsh')
	\&& substitute(system('tmuxsh co s'), '\n\+$', '', '') == 'light'
		se bg=light
	en

	if g:HasColorscheme('kanagawa-wave')
		Colorscheme kanagawa-wave
	elsei g:HasColorscheme('gruvbox-material')
		Colorscheme gruvbox-material
	elsei g:HasColorscheme('retrobox')
		Colorscheme retrobox
	elsei g:HasColorscheme('gruvbox')
		Colorscheme gruvbox
	el
		" None of the above colorschemes found.
		" Doing just nothing, assuming it’s a non-Nix setup and the plugins are not
		" installed yet.
	en
endf
