" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
"
" GUI-specific configuration for Neovim.

" TODO: Read current font state from command-line
" TODO: Expose s:detect() globally


" Applying local additional config
let g:local_guirc_pre = $HOME . '/.neovimrc-gui-local-pre'
if filereadable(g:local_guirc_pre) | exe 'so ' . g:local_guirc_pre | en


" Some constants for GUI program names (to avoid typos)
let s:neovide_gui = 'neovide'
let s:gtk_gui = 'neovim-gtk'
let s:qt_gui = 'neovim-qt'

" Detect which GUI program is currently running
fun! s:detect()
	if exists('g:neovide') | return s:neovide_gui
	elseif exists('g:GtkGuiLoaded') | return s:gtk_gui
	" neovim-qt does not provide any way to determine that it’s being used.
	" After trying anything else just assuming we are using neovim-qt.
	else | return s:qt_gui | en
endf

fun! s:is_neovide_gui()
	return s:detect() == s:neovide_gui
endf
fun! s:is_gtk_gui()
	return s:detect() == s:gtk_gui
endf
fun! s:is_qt_gui()
	return s:detect() == s:qt_gui
endf


" This key mapping doesn’t work in neovim-qt if it’s not re-defined here.
" Maybe neovim-qt overrides this mapping.
nn <C-Space> :CtrlSpace<CR>


" Changing the colorscheme for GUI based on the environment variables
if s:is_gtk_gui() && $TMUX == '' && $GTK_THEME =~ ':light$'
	se bg=light
	cal g:ColorschemeCustomizations()
en


" Turn-off GUI-provided tabline.
"
" It will force to render the tabline the same way it’s rendered in TUI.
" Works for neovim-gtk and for neovim-qt since a250faf from 25-07-2018.
" Earlier neovim-qt have been supposed to be run with --no-ext-tabline option.
if s:is_gtk_gui()
	cal rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
elseif s:is_qt_gui()
	cal rpcnotify(0, 'Gui', 'Option', 'Tabline', 0)
en


" Turn-off GUI-provided context menu
if s:is_gtk_gui()
	cal rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
en


" Animation settings
if s:is_neovide_gui()
	let g:neovide_scroll_animation_length = 1
	let g:neovide_cursor_vfx_mode = "pixiedust"
	let g:neovide_cursor_vfx_particle_density = 100
en


" Ligatures support.
"
" In Neovide these are turned on by default.
if s:is_gtk_gui()
	cal rpcnotify(1, 'Gui', 'FontFeatures', 'XHS0, XIDR, XELM, PURS')
elsei s:is_qt_gui()
	GuiRenderLigatures 1
en


" Turn off all scroll smoothing plugins when native Neovide smoothing is used.
"
" N.B. Note that Neovide can also be started with “--multigrid” command-line
" arguments option. In this case the plugins won’t be turned off automatically.
if s:is_neovide_gui() && $NEOVIDE_MULTIGRID
	let g:smoothie_enabled = 0
en


" Default font family and font size.
"
" If these were set before (just reloading the config) it will reuse the last
" value. It won’t be reset during config reloading.
if !exists('s:font_family')
	" Can customize font family before GUI starts
	if exists('g:initial_gui_font_family')
		let s:font_family = g:initial_gui_font_family
	" Can customize font before GUI starts.
	" Example value: ['Hack', '12']
	elseif exists('g:initial_gui_font') && len(g:initial_gui_font) >= 1
		let s:font_family = g:initial_gui_font[0]
	el
		let s:font_family = 'IosevkaTerm Nerd Font'
	en
en
if !exists('s:font_size')
	" Can customize font size before GUI starts
	if exists('g:initial_gui_font_size')
		let s:font_size = g:initial_gui_font_size
	" Can customize font before GUI starts.
	" Example value: ['Hack', '12']
	elseif exists('g:initial_gui_font') && len(g:initial_gui_font) >= 2
		let s:font_size = g:initial_gui_font[1]
	elseif s:is_neovide_gui()
		" In Neovide the font size renders significantly bigger.
		" In practice it’s (approximately) the same as for the other GUIs.
		let s:font_size = 9
	el
		let s:font_size = 13
	en
en

" Set the GUI font family and font size according to the internal configuration
fun! s:apply_font_settings()
	if s:is_neovide_gui()
		let &gfn = s:font_family.':h'.string(s:font_size)
	elseif s:is_gtk_gui()
		cal rpcnotify(1, 'Gui', 'Font', s:font_family.' '.string(s:font_size))
	elseif s:is_qt_gui()
		cal rpcnotify(0, 'Gui', 'Font', s:font_family.':h'.string(s:font_size))
	else
		th "Unknown GUI application"
	en
	redr!
endf

" Trigger setting the GUI font settings during config loading according to the
" provided internal configuration.
cal s:apply_font_settings()


" Change the GUI font family
fun! s:set_font_family(family)
	let s:font_family = a:family
	cal s:apply_font_settings()
endf

" A command alias to change the current GUI font family
com! -nargs=1 GuiFontFamily cal <SID>set_font_family(<args>)


" Minimal value for the font size.
"
" It sets the bound how small you can set the font size.
" Too small value may cause freezes because the amount of rendered chars on the
" screen is getting extreme.
let s:min_font_size = 6

" Decrease the GUI font size by the amount of given steps
fun! s:font_size_dec(count)
	let l:count = a:count | if l:count < 1 | let l:count = 1 | en
	let s:font_size = s:font_size - l:count
	if s:font_size < s:min_font_size | let s:font_size = s:min_font_size | en
	cal s:apply_font_settings()
endf

" Increase the GUI font size by the amount of given steps
fun! s:font_size_inc(count)
	let l:count = a:count | if l:count < 1 | let l:count = 1 | en
	let s:font_size = s:font_size + l:count
	if s:font_size < s:min_font_size | let s:font_size = s:min_font_size | en
	cal s:apply_font_settings()
endf

" Set the GUI font size to a specific value.
"
" WARNING! This function does not limit the bottom to “s:min_font_size”.
" It allows to set it to any possible value. This is intentional.
" While it’s easy to mess up the increase/decrease because you can repeat it,
" or just turn your mouse wheel so that it results into many steps in one go,
" no big need for a protection when setting the font size to a specific value.
fun! s:font_size_set(size)
	let s:font_size = str2nr(a:size)
	cal s:apply_font_settings()
endf

" Some command aliases for manipulating GUI font size
com! GuiFontSizeDec cal <SID>font_size_dec(1)
com! GuiFontSizeInc cal <SID>font_size_inc(1)
com! -nargs=1 GuiFontSizeDecN cal <SID>font_size_dec(<args>)
com! -nargs=1 GuiFontSizeIncN cal <SID>font_size_inc(<args>)
com! -nargs=1 GuiFontSizeSet cal <SID>font_size_set(<args>)

" Basic key mappings for manipulating the GUI font size.
"
" Can press 5<leader>+ to increase the font size by 5 steps.
nn <leader>- :<C-u>cal <SID>font_size_dec(v:count)<CR>
nn <leader>+ :<C-u>cal <SID>font_size_inc(v:count)<CR>
nn <leader>= :<C-u>cal <SID>font_size_inc(v:count)<CR>

" How much font size increases/decreases on one Ctrl + Mouse Scroll Wheel turn
let s:scroll_wheel_pace = 5

exe 'nn <expr> <C-ScrollWheelUp>   <SID>font_size_inc('.s:scroll_wheel_pace.')'
exe 'nn <expr> <C-ScrollWheelDown> <SID>font_size_dec('.s:scroll_wheel_pace.')'

" Double the step when Shift is also held
exe 'nn <expr> <C-S-ScrollWheelUp>   <SID>font_size_inc('.s:scroll_wheel_pace*2.')'
exe 'nn <expr> <C-S-ScrollWheelDown> <SID>font_size_dec('.s:scroll_wheel_pace*2.')'


" Applying local additional config
let g:local_guirc_post = $HOME . '/.neovimrc-gui-local-post'
if filereadable(g:local_guirc_post) | exe 'so ' . g:local_guirc_post | en
